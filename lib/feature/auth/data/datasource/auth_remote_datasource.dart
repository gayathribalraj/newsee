import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  /*
  @author     : karthick.d 14/05/2025
  @desc       : login api consumer - dio.post method 
                datasource directory encapsulated http services and setup like
                http interceptors etc
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */
  loginWithUserAccount(Map<String, dynamic> payload) async {
    // dio.options.baseUrl = ApiConfig.BASE_URL_QUERY;
    Response response = await dio.post(
      'MobileService/LoginService',
      data: {'Login': payload, 'token': ApiConfig.AUTH_TOKEN},
    );
    return response;
  }
}
