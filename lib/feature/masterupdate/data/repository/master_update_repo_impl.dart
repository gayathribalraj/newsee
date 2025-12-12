import 'package:dio/dio.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/masterupdate/data/datasource/master_update_datasource.dart';
import 'package:newsee/feature/masterupdate/domain/repository/master_update_repository.dart';

class MasterUpdateRepoImpl implements MasterUpdateRepository {
  @override
  Future<AsyncResponseHandler<Failure, Map<String, dynamic>>>
  getMastersVersion() async {
    try {
      final payload = {
        "vertical": ApiConfig.VERTICAL,
        "token": ApiConfig.AUTH_TOKEN,
      };
      print("payload-LandHoldingRespositoryImpl => $payload");
      final response = await MasterUpdateDatasource(
        dio: ApiClient().getDio(),
      ).downloadMasterVersion(payload);
      if (response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY]) {
        final Map<String, dynamic> masterdetail =
            response.data['responseData']['MasterDetails'];
        Globalconfig.masterVersionMapper = masterdetail;
        print(
          'Globalconfig.masterVersionMapper => ${Globalconfig.masterVersionMapper}',
        );
        return AsyncResponseHandler.right(masterdetail);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('Land Holding error => $errorMessage');
        return AsyncResponseHandler.left(
          HttpConnectionFailure(message: errorMessage),
        );
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error) {
      print("LandHoldingResponseHandler-> $error");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Land Holding Details",
        ),
      );
    }
  }
}
