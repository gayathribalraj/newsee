/* 
@author     : karthick.d  14/05/2025
@desc       : encapsulate state for authentication business logic
              have state object for UserModel which returns by the logi api

 */

part of 'auth_bloc.dart';

// we need following state status which is defines http init , loading
// success and failure

enum AuthStatus { init, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final String? errorMessage;
  final AuthResponseModel? authResponseModel;

  // private constructor for instance initialisation

  AuthState._({
    required this.authStatus,
    this.authResponseModel,
    this.errorMessage,
  });

  factory AuthState.init() => AuthState._(authStatus: AuthStatus.init);

  // setting state of instance variable On AuthEvents

  AuthState copyWith({
    AuthStatus? status,
    AuthResponseModel? authResponseModel,
    String? errorMessage,
  }) {
    return AuthState._(
      authStatus: status ?? authStatus,
      authResponseModel: authResponseModel ?? this.authResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [authStatus, authResponseModel, errorMessage];
}
