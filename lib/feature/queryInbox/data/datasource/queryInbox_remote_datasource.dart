import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';

class QueryInboxRemoteDatasource {
  final Dio dio;
  QueryInboxRemoteDatasource({required this.dio});

  Future<Response> getQueryInboxList(
    Map<String, dynamic> payload,
    endPoint,
  ) async {
    return await dio.post(
      endPoint,
      data: payload,
      options: Options(
        headers: {
          'token': ApiConfig.AUTH_TOKEN,
          'deviceId': ApiConfig.DEVICE_ID,
          'userid': 'IOB3',
        },
      ),
    );
  }
}
