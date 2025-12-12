import 'package:dio/dio.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/aadharvalidation/data/datasource/aadhar_validate_datasource.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_request.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/aadharvalidation/domain/repository/aadharvalidate_repo.dart';

/* 
@author   : Rajesh.S 10/06/2025
@desc     : This class extends AadharvalidateRepo and provides the implementation 
for validating an Aadhaar number. Validates an Aadhaar number using the provided request object.
Parameters:[request]: An instance of `AadharvalidateRequest`
Returns:- A `Future` containing an `AsyncResponseHandler`:
  - If the validation is successful, it returns a `right` containing an
    `AadharvalidateResponse`.
  - If validation fails or an error occurs, it returns a `left` containing
    a `Failure` object.

*/

class AadharValidateImpl extends AadharvalidateRepo {
  @override
  Future<AsyncResponseHandler<Failure, AadharvalidateResponse>> validateAadhar({
    required AadharvalidateRequest request,
  }) async {
    HttpConnectionFailure failure = HttpConnectionFailure(message: "");
    try {
      final responseData =
          Globalconfig.isOffline
              ? await offlineDataProvider(path: AppConstants.aadhaarResponse)
              : await AadharValidateDatasource(
                dio: ApiClient().getDio(),
              ).validateAadhaar(request);

      if (responseData.data['Success']) {
        final AadharvalidateResponse response = AadharvalidateResponse.fromMap(
          responseData.data['responseData']['data'],
        );
        return AsyncResponseHandler.right(response);
      } else {
        return AsyncResponseHandler.left(failure);
      }
    } on DioException catch (e) {
      HttpConnectionFailure failure =
          DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    }
  }
}
