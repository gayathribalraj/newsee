import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  Dio getDio() {
    Dio dio = Dio();
    dio.options.baseUrl = ApiConfig.BASE_URL;
    dio.options.headers = {
      'token': ApiConfig.AUTH_TOKEN,
      'deviceId': ApiConfig.AUTH_TOKEN,
    };
    dio.interceptors.add(
      PrettyDioLogger(
        responseHeader: true,
        responseBody: true,
        requestHeader: true,
        requestBody: true,
        request: true,
        compact: false,
      ),
    );

    return dio;
  }
}
