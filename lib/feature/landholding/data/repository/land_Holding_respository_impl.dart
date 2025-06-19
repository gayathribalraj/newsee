import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/landholding/data/datasource/landHolding_remote_datasource.dart';
import 'package:newsee/feature/landholding/domain/modal/group_land_Holding.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';

class LandHoldingRepositoryImpl implements LandHoldingRepository {
  @override
  Future<AsyncResponseHandler<Failure, List<GroupLandHolding>>> landHolding(
    LandHoldingRequest req,
  ) async {
    try {
      final payload = {'userid': req.userid, 'token': ApiConfig.AUTH_TOKEN};

      final response = await LandHoldingRemoteDatasource(
        dio: ApiClient().getDio(),
      ).landHolding(payload);

      final responseData = response.data;
      final isSuccess =
          responseData[ApiConfig.API_RESPONSE_SUCCESS_KEY] == true;

      if (isSuccess) {
        final data = responseData[ApiConfig.API_RESPONSE_RESPONSE_KEY];

        if (data is List) {
          final leadResponse =
              data
                  .map((e) => GroupLandHolding.fromMap(e as Map<String, dynamic>))
                  .toList();
          return AsyncResponseHandler.right(leadResponse);
        } else if (data is Map<String, dynamic>) {
          final leadResponse = GroupLandHolding.fromMap(data);
          return AsyncResponseHandler.right([leadResponse]);
        } else {
          return AsyncResponseHandler.left(
            HttpConnectionFailure(
              message: "Unexpected data format: ${data.runtimeType}",
            ),
          );
        }
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error, st) {
      print(" LeadResponseHandler Exception: $error\n$st");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(message: "Unexpected Failure during Lead Search"),
      );
    }
  }
}
