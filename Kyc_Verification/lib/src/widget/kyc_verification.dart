/*
  @author   : Gayathri
  @created  : 10/11/2025
  @desc     :VerificationMixin to handle online and offline verification logic using
   Dio for API calls and rootBundle for asset loading.
*/

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

mixin VerificationMixin {
  Future<Response> verifyOnline(String url);

  Future<Response> verifyOffline(String assetPath);
}

// handle verify offline rootBundle for asset loading.

class OfflineVerificationHandler {
  static Future<Response> loadData(String assetPath) async {
    final String res = await rootBundle.loadString(assetPath);
    return Response(
      data: json.decode(res),
      requestOptions: RequestOptions(path: assetPath),
    );
  }
}

//handle verify online Dio for API calls

class ApiClient {
  final Dio dio = Dio();

  Future<Response> callPost(String url, {data}) async {
    dio.options.headers = {
      'clientID': '220',
      'productID': '1',
      'appno': '100050000000004',
      'module': 'MSME',
      'branch': 'Chennai',
      'user': 'user845',
      'cp-client-trans-id': '1763037635616',
      'cbsid': '',
    };

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
    return await dio.post(url, data: data);
  }

  Future<Response> callGet(String url) async {
    return await dio.get(url);
  }
}
