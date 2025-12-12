import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';

class CicRemoteDatasource {
  final Dio dio;

  CicRemoteDatasource({required this.dio});

  Future<Response> searchCibil(payload) async {
    Response response = await dio.post(
      ApiConfig.CIBIL_API_ENDPOINT,
      data: payload,
      options: Options(
        headers: {
          'token': ApiConfig.AUTH_TOKEN,
          'deviceId': ApiConfig.DEVICE_ID,
          'userid': '4321',
        },
      ),
    );
    return response;
  }
}
