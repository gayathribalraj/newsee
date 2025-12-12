/* 

@author       :   karthick.d  07/05/2025 
@description  :   Login State Class definition
@params       :   LoginState enum , LoginResponse model 

 */

/*
 to import  sealed class in another package or class must be include part of keyword so this class
can be imported in anothe file like part 'login_state' - refer login_bloc.dart
*/

part of 'login_bloc.dart';

// enum type for distinct descriptive loginstatus
enum LoginStatus { init, fetch, success, error }

// base sealed class which encapsulates Login state properties
// provided to the Bloc<loginEvent,loginState> in the presentation layer

final class LoginState extends Equatable {
  final LoginResponse loginResponse;
  final LoginStatus loginStatus;
  final bool isPasswordHidden;
  LoginState({
    this.loginStatus = LoginStatus.init,
    required this.loginResponse,
    this.isPasswordHidden = true,
  });

  /*
  @author         :   karthick.d  07-05-2025
  @description    :   copyWith method returns a copy of LoginState Instance 
                      with the copy of incoming values and 
  @params         :   loginStatus and loginResponse object
  @return         :   LoginState

  */

  LoginState copyWith({
    LoginStatus? status,
    LoginResponse? response,
    bool? isPasswordShown,
  }) {
    return LoginState(
      loginStatus: status ?? loginStatus,
      loginResponse: response ?? loginResponse,
      isPasswordHidden: isPasswordShown ?? isPasswordHidden,
    );
  }

  @override
  List<Object?> get props => [loginResponse, loginStatus, isPasswordHidden];

  @override
  String toString() {
    return ''' LoginState { LoginResponse ${loginResponse.toString()}} ,
              LoginStatus : $loginStatus , isPasswordHidden : $isPasswordHidden
     ''';
  }
}
