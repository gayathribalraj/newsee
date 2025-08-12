import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';

class AadharValidateDatasource {
  final Dio dio;
  AadharValidateDatasource({required this.dio});

  /*
  @author     : Rajesh. S 05/06/2025
  @desc       : validate aadhar number and fetch the aadhar response using dio.post method.
  @param      : http request payload containing aadhaarNumber
  @return     : Future<Response> Response - > HttpResponse
   */

  Future<Response> validateAadhaar(payload) async {
    return await dio.post(
      ApiConfig.AADHAAR_API_ENDPOINT,
      data: {
        "aadhaarNumber": payload,
        "token":
            "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3",
      },
    );
  }
}
