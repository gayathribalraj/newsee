import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newsee/blocs/cif/data/datasource/cif_remote_datasource.dart';
import 'package:newsee/blocs/cif/domain/model/user/cif_response_model.dart';
import 'package:newsee/blocs/cif/domain/repository/cif_repository.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';

class CifRepositoryImpl implements CifRepository {
  final CifRemoteDatasource cifRemoteDatasource;

  CifRepositoryImpl({required this.cifRemoteDatasource});

  @override
  Future<AsyncResponseHandler<Failure, CifResponseModel>> searchCif(
    Map<String, dynamic> req,
  ) async {
    try {
      print('CIF Search request payload => $req');
      var response = await cifRemoteDatasource.searchCif(req);

      if (response.data['Success']) {
        var cifResponse = CifResponseModel.fromJson(
          response.data['responseData'],
        );
        print('CifResponseModel => ${cifResponse.toString()}');
        return AsyncResponseHandler.right(cifResponse);
      } else {
        var errorMessage = response.data['ErrorMessage'] ?? "Unknown error";
        print('CIF Search error => $errorMessage');
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        return AsyncResponseHandler.left(
          AuthFailure(
            message: "Could not reach server. Please try again later.",
          ),
        );
      }
      return AsyncResponseHandler.left(
        AuthFailure(message: "Server Error Occurred"),
      );
    } on Exception {
      return AsyncResponseHandler.left(
        AuthFailure(message: "Unexpected Failure during CIF Search"),
      );
    }
  }
}
