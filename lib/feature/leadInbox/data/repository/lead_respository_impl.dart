import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/leadInbox/data/datasource/lead_remote_datasource.dart';
import 'package:newsee/feature/leadInbox/domain/modal/get_lead_response.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_responce_model.dart';
import 'package:newsee/feature/leadInbox/domain/repository/lead_repository.dart';

/*
@author       :  gayathri.b 12/05/2025 by
@description   : Implements the [LeadRepository] interface to perform lead search functionality.
                  It uses [LeadRemoteDatasource] to make a network request through Dio.
                  Handles API success and failure responses, including data parsing and error types.
 @returns       : [Future] of [AsyncResponseHandler] containing either a [Failure] or a list of [LeadResponseModel].
*/

class LeadRepositoryImpl implements LeadRepository {
  @override
  Future<AsyncResponseHandler<Failure, LeadResponseModel>> searchLead(
    LeadInboxRequest req,
  ) async {
    try {
      /* 
        pageno - leadslist 
        map<int,List<GroupLeadInbox>>> cachedLeadInbox = {
          1 : [
            ...GroupLeadInbox
          ],
          2:[
                        ...GroupLeadInbox

          ]
        }
        check the cache 
       */

      final endPoint = ApiConfig.LEAD_INBOX_API_ENDPOINT;

      final response = await LeadRemoteDatasource(
        dio: ApiClient().getDio(),
      ).searchLead(req.toMap(), endPoint);

      final responseData = response.data;
      final isSuccess =
          responseData[ApiConfig.API_RESPONSE_SUCCESS_KEY] == true;

      if (isSuccess) {
        final data = responseData[ApiConfig.API_RESPONSE_RESPONSE_KEY]['finalList'];
        final totCount = responseData[ApiConfig.API_RESPONSE_RESPONSE_KEY]['totalRecordCount'];

        if (data is List) {
          final leadResponse =
              data
                  .map((e) => GroupLeadInbox.fromMap(e as Map<String, dynamic>))
                  .toList();
              final leadResponseModel = LeadResponseModel(
                listOfApplication: leadResponse,
                totalApplication: totCount
              );
          return AsyncResponseHandler.right(leadResponseModel);
        } else if (data is Map<String, dynamic>) {
          final leadResponse = GroupLeadInbox.fromMap(data);
          final leadResponseModel = LeadResponseModel(
                listOfApplication: [leadResponse],
                totalApplication: 1
              );
          return AsyncResponseHandler.right(leadResponseModel);
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

  @override
  Future<AsyncResponseHandler<Failure, GetLeadResponse>> getLeadData(request) async {
    try {
      final endPoint = ApiConfig.GET_LEAD_DETAILS;
      final response = await LeadRemoteDatasource(
        dio: ApiClient().getDio(),
      ).searchLead(request, endPoint);

      final isSuccess = response.data[ApiConfig.API_RESPONSE_SUCCESS_KEY] == true;
      final responseData = response.data[ApiConfig.API_RESPONSE_RESPONSE_KEY];

      if (isSuccess) {
        GetLeadResponse getleadResponse = GetLeadResponse.fromMap(responseData);
        return AsyncResponseHandler.right(getleadResponse);
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
