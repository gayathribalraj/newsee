import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/audit_logs/domain/modal/auditlog.dart';
import 'package:newsee/feature/audit_logs/domain/repository/audit_log_crud_repo.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/io.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqlite_api.dart';

class ApiClient {
  Dio getDio() {
    try {
      Dio dio = Dio();
      if (ApiConfig.isUAT == true) {
        dio.options.baseUrl = ApiConfig.BASE_URL_UAT;
      } else {
        if (ApiConfig.isAWS == true) {
          // AWS QA URL
          dio.options.baseUrl = ApiConfig.BASE_URL_AWS;
        } else {
          // local QA URL
          dio.options.baseUrl = ApiConfig.BASE_URL;
        }
      }

      dio.options.headers = {
        'token': ApiConfig.AUTH_TOKEN,
        'deviceId': ApiConfig.DEVICE_ID,
        'userid': 'IOB3',
      };

      if (ApiConfig.isUAT == true) {
        // allow self-signed certificates (for UAT only)
        (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }

      //  await getSSLCertificatePinning(dio);

      dio.interceptors.add(
        PrettyDioLogger(
          responseHeader: true,
          responseBody: true,
          requestHeader: true,
          requestBody: true,
          request: true,
          compact: false,
        ),
      );
      // dio.interceptors.add(ConnectivityInterceptor());
      return dio;
    } catch (e) {
      print('getDio: $e');
      rethrow;
    }
  }

  // ssl certificate pinning
  Future<void> getSSLCertificatePinning(Dio dio) async {
    try {
      // load the correct certificate of UAT or PROD
      final certData = await rootBundle.load(ApiConfig.sslCertPath);
      final pinnedCertBytes = certData.buffer.asUint8List();

      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient(context: SecurityContext());

        client.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) {
          final serverHash = sha256.convert(cert.der).toString();
          final pinnedHash = sha256.convert(pinnedCertBytes).toString();

          if (serverHash == pinnedHash) {
            print('SSL verified successfully for $host');
            return true;
          } else {
            print(
              'SSL verification failed for $host\nExpected: $pinnedHash\nGot: $serverHash',
            );
            return false;
          }
        };
        return client;
      };
    } catch (e) {
      print('SSL setup error: $e');
    }
  }
}

// Custom Interceptor for Internet Connectivity Check
class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check internet connectivity
    insertRequestinDB(options);
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'NoInternetException',
          message: 'Please check your internet connection',
        ),
      );
      return;
    } else {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Proceed with the response
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors
    handler.next(err);
  }
}

Future<void> insertRequestinDB(RequestOptions options) async {
  Database db = await DBConfig().database;

  AuditLogCrudRepo auditLogCrudRepo = AuditLogCrudRepo(db);

  final userId = options.headers['userid'] ?? 'unknown';
  final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  final deviceId = options.headers['deviceId'] ?? 'unknown';
  final requestDetails = {
    'url': options.uri.toString(),
    'headers': options.headers,
    'data': options.data,
    'baseUrl': options.baseUrl,
  };

  final log = AuditLog(
    userid: userId.toString(),
    timestamp: timestamp,
    deviceId: deviceId,
    request: jsonEncode(requestDetails),
  );
  await auditLogCrudRepo.save(log);

  print('Save Audit log in db $log');
}
