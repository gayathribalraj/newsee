
import 'package:dio/src/response.dart';
import 'package:kyc_verification/src/core/api/api_config.dart';
import 'package:kyc_verification/src/widget/kyc_verification.dart';
import 'package:kyc_verification/src/widget/uiwidgetprops/voterid_request.dart';

class VoterVerified with VerificationMixin {
  // create instance of class apiclient
  final ApiClient apiClient = ApiClient();


  @override
  Future<Response> verifyOnline(String url, {VoteridRequest? request}) {
    return ApiClient().callPost(ApiConfig.VoterId, data: request!.toJson());
  }

  @override
  Future<Response> verifyOffline(String assetPath) async {
    return await OfflineVerificationHandler.loadData(assetPath);
  }
}
