import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource({required this.dio});

  /*
  @author     : karthick.d 14/05/2025
  @desc       : login api consumer - dio.post method 
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */
  loginWithUserAccount(Map<String, dynamic> payload) async {
    Response response = await dio.post(
      'LoginService',
      data: {'Login': payload, 'token': ApiConfig.AUTH_TOKEN},
    );
    return response;
  }
}
