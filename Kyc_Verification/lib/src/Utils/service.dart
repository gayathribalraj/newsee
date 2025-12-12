import 'package:dio/dio.dart';
import 'package:kyc_verification/src/widget/kyc_verification.dart';

class KYCService extends KycVerification{
  Future<Response> verify({
    required bool isOffline,
    String? request,
    String? url,
    String? assetPath,
  }) async {
    try {
      if (isOffline && assetPath != null) {
        return await verifyOffline(assetPath);
      } else if (!isOffline && url != null) {
        return await verifyOnline(url);
      } else {
        throw Exception('No data source provided');
      }
    } catch (error) {
      throw Exception(error.toString);
    }
    
  }
    
}

class KycVerification with VerificationMixin {
 @override
  Future<Response> verifyOffline(String assetPath) =>
      OfflineVerificationHandler.loadData(assetPath);

  @override
  Future<Response> verifyOnline(String url) async => ApiClient().callGet(url);
}