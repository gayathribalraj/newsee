
import 'package:dio/src/response.dart';
import 'package:kyc_verification/src/core/api/api_config.dart';
import 'package:kyc_verification/src/widget/kyc_verification.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/pan_request.dart';

class PanVerified with VerificationMixin {
  // create instance of class apiclient
  final ApiClient apiClient = ApiClient();


  @override
  Future<Response> verifyOnline(String url, {PanidRequest? request}) {
    return ApiClient().callPost(ApiConfig.Pancard, data: request!.toJson());
  }

  @override
  Future<Response> verifyOffline(String assetPath) async {
    return await OfflineVerificationHandler.loadData(assetPath);
  }
}
