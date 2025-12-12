import 'dart:convert';
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
import 'package:newsee/feature/cif/data/datasource/cif_remote_datasource.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/cif/domain/repository/cif_repository.dart';

class CifRepositoryImpl implements CifRepository {
  @override
  Future<AsyncResponseHandler<Failure, CifResponse>> searchCif(
    CIFRequest req,
  ) async {
    try {
      final payload = req.toJson();
      print('CIF Search request payload => $payload');
      // call remote or offline data source
      var response =
          Globalconfig.isOffline
              ? await offlineDataProvider(path: AppConstants.cifResponsonse)
              : await CifRemoteDatasource(
                dio: ApiClient().getDio(),
              ).searchCif(payload);

      final data = response.data;
      print('Raw CIF API response => $data');
      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        // final responseContent = data[ApiConfig.API_RESPONSE_KEY];
        // final responseJson =
        //     responseContent is String
        //         ? json.decode(responseContent)
        //         : responseContent ?? {};

        // final cifResponse = CifResponse.fromJson(
        //   responseJson['data']['ApplicantDetails'],
        // );
        final cifResponse = CifResponse.fromJson(
          response.data[ApiConfig
              .API_RESPONSE_RESPONSE_KEY]['lpretLeadDetails'],
        );
        String depositAmount =
            response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY]['depositAmount'];
        String depositCount =
            response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY]['depositCount'];
        String liabilityCount =
            response.data[ApiConfig
                .API_RESPONSE_RESPONSE_KEY]['liabilityCount'];
        String liabilityAmount =
            response.data[ApiConfig
                .API_RESPONSE_RESPONSE_KEY]['liabilityAmount'];
        String cifFlag =
            response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY]['cifFlag'];

        CifResponse _cifresponse = cifResponse.copyWith(
          cifFlag: cifFlag,
          liabilityCount: liabilityCount,
          liabilityAmount: liabilityAmount,
          depositCount: depositCount,
          depositAmount: depositAmount,
        );
        print('ChifResponseModel => ${_cifresponse.toString()}');

        return AsyncResponseHandler.right(_cifresponse);
      } else {
        final String errorMessage =
            data[ApiConfig.API_RESPONSE_ERRORMESSAGE_KEY] ?? 'Unknown error';
        print('CIF Search error => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("cifResponseHandler -> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: "Unexpected Failure during CIF Search"),
      );
    }
  }
}
