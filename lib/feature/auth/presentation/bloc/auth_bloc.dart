/* 
@author     : karthick.d 14/05/2025
@desc       : bloc class that encapsullates business logic components 
              listen to events on() and emits new state
@param      : AuthEvent and AuthState

 */
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Model/api_core/AsyncResponseHandler.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/feature/auth/domain/model/user/auth_response_model.dart';
import 'package:newsee/feature/auth/domain/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState.init()) {
    on<LoginWithAccount>(onLoginWithAccount);
  }

  Future onLoginWithAccount(LoginWithAccount event, Emitter emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    AsyncResponseHandler response = await authRepository.loginWithAccount(
      event.loginRequest,
    );
    // check if response i success and contains valid data , success status is emitted
    if (response.isRight()) {
      emit(
        state.copyWith(
          status: AuthStatus.success,
          authResponseModel: response.right,
        ),
      );
    } else {
      print('auth failure response.left ');
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: response.left.message,
        ),
      );
    }
  }
}
