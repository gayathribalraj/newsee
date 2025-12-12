import 'package:dio/dio.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/core/api/api_config.dart';

class DocumentDataSource {
  final Dio dio;
  DocumentDataSource({required this.dio});

  /*
  @author     : lathamani 1/07/2025
  @param      : http request payload
  @return     : Future<Response> Response - > HttpResponse
   */
  uploadDocument(FormData payload) async {
    final res = await dio.post(ApiConfig.UPLOAD_DOCUMENT, data: payload);
    return res;
  }
  uploadVideo(FormData payload) async {
    final res = await dio.post(ApiConfig.UPLOAD_VIDEO, data: payload);
    return res;
  }

  Future<Response> getDocuments(Map<String, dynamic> payload) async {
    final res =
        Globalconfig.isOffline
            ? await offlineDataProvider(path: AppConstants.documentsResponse)
            : await dio.post(ApiConfig.GET_DOCUMENTS, data: payload);
    return res;
  }

  Future<Response> fetchUploadedDocument(Map<String, dynamic> payload) async {
    final res = await dio.post(ApiConfig.FETCH_UPLOAD_DOCUMENT, data: payload);
    return res;
  }

  Future<Response> deleteUploadedDocument(Map<String, dynamic> payload) async {
    final res = await dio.post(ApiConfig.DELETE_UPLOAD_DOCUMENT, data: payload);
    return res;
  }
}
