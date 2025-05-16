/* 

@author         : karthick.d
@created        : 13/05/2025
@desc           : encapsulates method that either resolve and give 
                  user_details or return failure model
 */
import 'package:newsee/Model/api_core/AsyncResponseHandler.dart';
import 'package:newsee/Model/api_core/failure.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/feature/auth/domain/model/user/auth_response_model.dart';

abstract class AuthRepository {
  Future<AsyncResponseHandler<Failure, AuthResponseModel>> loginWithAccount(
    LoginRequest loginRequest,
  );
}
