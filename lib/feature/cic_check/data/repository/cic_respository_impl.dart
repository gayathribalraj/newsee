import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/cic_check/data/datasource/cic_remote_datasource.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_response_model.dart';
import 'package:newsee/feature/cic_check/domain/modals/cic_request.dart';
import 'package:newsee/feature/cic_check/domain/repository/cic_repository.dart';

class CicRepositoryImpl implements CicRepository {
  @override
  Future<AsyncResponseHandler<Failure, CibilResponse>> searchCibil(
    CICRequest req,
  ) async {
    try {
      final payload = req.toJson();
      print('Cibil Search request payload => $payload');
      // Call remote or offline data source
      var response =
          Globalconfig.isOffline
              ? await offlineDataProvider(path: AppConstants.cibilResponsonse)
              : await CicRemoteDatasource(
                dio: ApiClient().getDio(),
              ).searchCibil(payload);

      // Normalize response

      // final data = response.data;
      print('Raw Cibil API response => $response.data');
      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        final report = await offlineDataProvider(
          path: AppConstants.cibilResponsonse,
        );

        final data = report.data;
        print('Raw Cibil API response => $data');
        final responseString = data[ApiConfig.API_RESPONSE_KEY];
        final responseJson = json.decode(responseString);
        print('Cibil responseJson => $responseJson');
        // final cibilData =
        //     responseJson['ContextData']['Field'][0]['Applicants']['Applicant']['DsCibilBureau'];
        // final score =
        //     cibilData['Response']['CibilBureauResponse']['BureauResponseXml']['CreditReport']['ScoreSegment'][0];
        // responseJson['cibilScore'] = score['Score'].toString();
        responseJson['cibilScore'] = '00830';
        // print('${score['Score']}, $score');
        final cibilResponse = CibilResponse.fromJson(responseJson);

        print('Parsed cibilres => $cibilResponse');
        return AsyncResponseHandler.right(cibilResponse);
      } else {
        final String errorMessage =
            response.data[ApiConfig.API_RESPONSE_ERRORMESSAGE_KEY] ??
            'Unknown error';
        print('cibil Search error => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("cibilResponseHandler -> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Cibil Search",
        ),
      );
    }
  }
}
