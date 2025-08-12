import 'package:dio/dio.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';

/*
@author   : Rajesh. S  12/06/2025 
@Desc     : Data source for fetching city and district lists from the server.
Provides methods for interacting with APIs to fetch city and district data.
 */
class CityDatasource {
  final Dio dio;
  CityDatasource({required this.dio});

  fecthCityList(payload) async {
    Response response = await dio.post(
      ApiConfig.GETCITY_API_ENDPOINT,
      data: {
        "stateCode": payload,
        "token":
            "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3",
      },
    );
    return response;
  }

  Future<Response> fecthDistrictList(CityDistrictRequest payload) async {
    return await dio.post(
      ApiConfig.GETDISCTRICT_API_ENDPOINT,
      data: {
        "stateCode": payload.stateCode,
        "cityCode": payload.cityCode,
        "token":
            "U2FsdGVkX1/Wa6+JeCIOVLl8LTr8WUocMz8kIGXVbEI9Q32v7zRLrnnvAIeJIVV3",
      },
    );
  }
}
