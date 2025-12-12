import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/queryInbox/data/datasource/queryInbox_remote_datasource.dart';
import 'package:newsee/feature/queryInbox/domain/modal/queryInbox_request_modal.dart';
import 'package:newsee/feature/queryInbox/domain/modal/queryInbox_response_modal.dart';
import 'package:newsee/feature/queryInbox/domain/modal/query_request_modal.dart';
import 'package:newsee/feature/queryInbox/domain/modal/query_response_modal.dart';
import 'package:newsee/feature/queryInbox/domain/repository/query_repository.dart';

class QueryRepositoryImpl implements QueryRepository {
  @override
  Future<AsyncResponseHandler<Failure, QueryInboxResponseModal>>
  getQueryInboxList(QueryInboxRequestModal req) async {
    try {
      final endPoint = ApiConfig.GET_QUERY_INBOX_LIST;

      final response = await QueryInboxRemoteDatasource(
        dio: ApiClient().getDio(),
      ).getQueryInboxList(req.toJson(), endPoint);

      final responseData = response.data;
      final isSuccess =
          responseData[ApiConfig.API_RESPONSE_SUCCESS_KEY] == true;

      if (isSuccess) {
        final result = QueryInboxResponseModal.fromJson(responseData);

        return AsyncResponseHandler.right(result);
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error, st) {
      print(" QueryResponseHandler Exception: $error\n$st");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Query Inbox Search",
        ),
      );
    }
  }

  @override
  Future<AsyncResponseHandler<Failure, QueryResponseModal>>
  getQueryResponseList(QueryRequestModal req) async {
    try {
      final endPoint = ApiConfig.GET_QUERY_DETAILS_TEXT;

      final response = await QueryInboxRemoteDatasource(
        dio: ApiClient().getDio(),
      ).getQueryInboxList(req.toJson(), endPoint);

      final responseData = response.data;
      final isSuccess =
          responseData[ApiConfig.API_RESPONSE_SUCCESS_KEY] == true;

      if (isSuccess) {
        final result = QueryResponseModal.fromJson(responseData);

        return AsyncResponseHandler.right(result);
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error, st) {
      print(" QueryResponseHandler Exception: $error\n$st");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Query Inbox Search",
        ),
      );
    }
  }
}
