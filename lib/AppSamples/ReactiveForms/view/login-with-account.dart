import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/globalconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/config/appconfig.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login_mpin.dart';
import 'package:newsee/feature/creatempin/presentation/page/create_mpin.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/loginwithblocprovider.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/Utils/masterversioncheck.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsee/feature/globalconfig/bloc/global_config_bloc.dart';
import 'package:newsee/feature/masters/domain/modal/master_request.dart';
import 'package:newsee/feature/masters/domain/modal/master_version.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*

@author : Gayathri.b    12/05/2025
@description :  This function displays a Cupertino-style modal bottom sheet containing 
                a login form implemented using the `ReactiveForms` package and Bloc pattern.
                It uses a gradient background and dynamically adapts its size based on 
                screen width and height.

@props      :
  - BuildContext context : The context in which the bottom sheet is presented.
 */

void loginActionSheet(
  BuildContext context,
  OperationNetwork networkState, {
  bool createMPIN = false,
}) {
  //dynamically adapts its size based on  screen width and height.
  final double screenwidth = MediaQuery.of(context).size.width;
  final double screenheight = MediaQuery.of(context).size.height;
  final bool isCreateMpin = createMPIN;
  showCupertinoModalPopup(
    context: context,

    builder:
        (BuildContext context) => SingleChildScrollView(
          child: Container(
            //It uses a gradient background
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(10),
            width: screenwidth * 1.0,
            height: screenheight * 0.75,
            child: LoginBlocProvide(isCreateMpin, networkState),
          ),
        ),
  );
}

class LoginpageWithAC extends StatelessWidget {
  // createPIN is true then after successful attempt of loginwithaccount ,
  // createMPIN bottomsheet will be called

  final bool? createPIN;
  final OperationNetwork network;
  const LoginpageWithAC(this.createPIN, this.network);

  @override
  Widget build(BuildContext context) {
    final loginFormgroup = AppConfig().loginFormgroup;

    login(AuthState state) {
      print('Globalconfig.isOffline => ${Globalconfig.isOffline}');

      if (loginFormgroup.valid) {
        context.read<AuthBloc>().add(
          LoginWithAccount(
            loginRequest: LoginRequest(
              username: loginFormgroup.value['username'] as String,
              password: loginFormgroup.value['password'] as String,
            ),
          ),
        );
        print(state.toString());

        //context.goNamed('home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
    }

    offlineLogin() {
      print('Globalconfig.isOffline => ${Globalconfig.isOffline}');
      Globalconfig.masterVersionMapper = {
        "Listofvalues": "5",
        "ProductMaster": "5",
        "ProductScheme": "5",
        "StateCityMaster": "2",
      };
      context.goNamed('masters');
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        switch (state.authStatus) {
          case AuthStatus.success:
            print('LoginStatus.success... ${state.authResponseModel}');
            AsyncResponseHandler<bool, List<MasterVersion>>
            masterVersionCheckResponseHandler = await compareVersions(
              Globalconfig.masterVersionMapper,
            );
            print(
              'masterVersionCheckResponseHandler.isLeft => ${masterVersionCheckResponseHandler.isLeft()}',
            );

            print(
              'masterVersionCheckResponseHandler.isRight => ${masterVersionCheckResponseHandler.isRight()}',
            );
            /* 
              important : masterversion check based masterdownload happeing here
                          Asynresponsehandler response eigther return List<MasterVersion>
                          if masterupdate is required and list of mastertype that haev updated
                          master version will be returned
                          otherwise null will be returned in left

             */
            if (createPIN!) {
              context.pop(loginActionSheet);
              createMpin(context, masterVersionCheckResponseHandler);
              return;
            }
            if (masterVersionCheckResponseHandler.isLeft()) {
              context.goNamed('masters');
            } else if (masterVersionCheckResponseHandler.isRight()) {
              if (masterVersionCheckResponseHandler.right.isNotEmpty) {
                Globalconfig.diffListOfMaster =
                    masterVersionCheckResponseHandler.right;
                print(
                  "Globalconfig.diffListOfMaster ${Globalconfig.diffListOfMaster}",
                );
                context.goNamed('masters');
              } else {
                context.goNamed('home');
              }
            }
          case AuthStatus.loading:
            print('LoginStatus.loading...');

          case AuthStatus.init:
            print('LoginStatus.init...');

          case AuthStatus.failure:
            //context.goNamed('home');
            print('LoginStatus.error...');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login Failed...')),
            );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // final globalConfig = context.watch<GlobalConfigState>().globalconfig;
          final isLoading = state.authStatus == AuthStatus.loading;
          print('state.authStatus => ${state.authStatus}');
          final isPasswordHidden = state.isPasswordHidden;
          print(
            'in build function isPasswordHidden=> ${state.isPasswordHidden}',
          );
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(25),
            // login form implemented using the `ReactiveForms` package and Bloc pattern
            child: SingleChildScrollView(
              child: ReactiveForm(
                formGroup: loginFormgroup,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Text(
                      "Welcome to our platform!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A3D62),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Let's get started",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 25),

                    // Username Input
                    ReactiveTextField(
                      formControlName: 'username',
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "@username",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validationMessages: {
                        ValidationMessage.required:
                            (_) => 'Username is Required',
                      },
                    ),
                    const SizedBox(height: 25),

                    // Password Input
                    ReactiveTextField(
                      formControlName: 'password',
                      obscureText: isPasswordHidden,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            context.read<AuthBloc>().add(PasswordSecure());
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validationMessages: {
                        ValidationMessage.required:
                            (_) => 'Password is Required',
                      },
                    ),
                    const SizedBox(height: 25),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 3, 9, 110),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  switch (network) {
                                    case OperationNetwork.offline:
                                      offlineLogin();
                                    case OperationNetwork.online:
                                      login(state);
                                  }
                                },
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
