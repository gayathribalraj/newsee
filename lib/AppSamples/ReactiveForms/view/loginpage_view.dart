import 'package:flutter/material.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/login-with-account.dart';
import 'forgetpassword.dart';
import 'maintain.dart';
import 'reachus.dart';
import 'more.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppSamples/ReactiveForms/config/appconfig.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/blocs/login/login_bloc.dart';
import 'package:newsee/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginpageView extends StatelessWidget {
  void fingerPrintScanner() {
    print('clicked finger print');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Center(child: Image.asset('assets/logo1.jpg', width: 200)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hello,\nUser",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.notifications_none,
                        size: 30,
                        color: Colors.deepPurpleAccent,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      gradient: LinearGradient(
                        colors: [const Color(0xC5F1ECF1), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        IconButton(
                          onPressed: () {
                            fingerPrintScanner();
                          },
                          icon: Icon(Icons.fingerprint),
                          iconSize: 60,
                          color: const Color.fromARGB(255, 3, 9, 110),
                        ),

                        Text(
                          "Login with Fingerprint",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Frequently used features & special offers at your fingertips",
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.calculate_rounded),
                                    iconSize: 40,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    'Emi Calculator',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.local_offer),
                                    iconSize: 40,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    'Send Money',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.shopping_bag),
                                    iconSize: 40,
                                    color: Colors.pink,
                                  ),
                                  Text(
                                    'pay Bills',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                      loginActionSheet(
                        context,
                       );
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginBlocProvide()),);
                      },
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text(
                        "Login with Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 50),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(246, 4, 13, 95),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // mpin(context);
                       
                      },
                      child: Text("Or, login with mPIN"),
                    ),
                    TextButton(
                      onPressed: () {
                        forgetActionSheet(
                          context,
                          "Reset mPIN for \n Customer ID *****8977",
                          "Let's first Verify it's you ,before you reset the mPIN. \n it'll be super quick and easy.",
                          (Icons.lock),
                          "Cancel",
                          "Continue",
                        );
                      },
                      child: Text("Forgot mPIN?"),
                    ),
                  ],
                ),
                SizedBox(height: 150),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            maintenanceActionSheet(
                              context,
                              "Comming Soon....",
                              "We are Working to improve Your experence with our new mobile app.",
                              Icons.person,
                              "okay",
                            );
                          },
                          icon: Icon(
                            Icons.medical_information,
                            color: const Color.fromARGB(246, 4, 13, 95),
                          ),
                          label: Text(
                            'Maintenance',
                            style: TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            reachUsActionSheet(
                              context,
                              "Reach Us...",
                              "Whatsapp",
                              "ContactUs",
                              "BranchLocator",
                              Icons.phone,
                              Icons.location_pin,
                            );
                          },
                          icon: Icon(
                            Icons.movie_creation_rounded,
                            color: const Color.fromARGB(246, 4, 13, 95),
                          ),
                          label: Text(
                            'Reach Us',
                            style: TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            moreActionSheet(
                              context,
                            'Okay'
                            );

                          },
                          icon: Icon(
                            Icons.more,
                            color: const Color.fromARGB(246, 4, 13, 95),
                          ),
                          label: Text(
                            'More',
                            style: TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
    // fakeLogin(AuthState state) {
    //   if (loginFormgroup.valid) {
    //     context.read<LoginBloc>().add(
    //       LoginFetch(
    //         loginRequest: LoginRequest(
    //           username: loginFormgroup.value['username'] as String,
    //           password: loginFormgroup.value['password'] as String,
    //         ),
    //       ),
    //     );
    //     print(state.toString());

    //     //context.goNamed('home');
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Please fill in all required fields')),
    //     );
    //   }
    // }

    login(AuthState state) {
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

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state.authStatus) {
          case AuthStatus.success:
            print('LoginStatus.success...');
            context.goNamed('home');
          case AuthStatus.loading:
            print('LoginStatus.loading...');

          case AuthStatus.init:
            print('LoginStatus.init...');

          case AuthStatus.failure:
            print('LoginStatus.error...');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login Failed...')),
            );
        }
        ;
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state.authStatus == AuthStatus.loading;
          print('state.authStatus => ${state.authStatus}');
          return Container(
            padding: const EdgeInsets.only(top: 20),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(235, 2, 34, 66),
                  const Color.fromARGB(211, 36, 12, 171),
                ],
              ),
            ),
            child: ReactiveForm(
              formGroup: loginFormgroup,
              child: Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ReactiveTextField(
                        formControlName: 'username',
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validationMessages: {
                          ValidationMessage.required:
                              (error) => 'UserName is Required',
                          ValidationMessage.contains:
                              (error) => error as String,
                        },
                      ),
                      SizedBox(height: 10.0),
                      ReactiveTextField(
                        formControlName: 'password',
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validationMessages: {
                          ValidationMessage.required:
                              (error) => 'Password is Required',
                          ValidationMessage.contains:
                              (error) => error as String,
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Colors.blue,
                          ),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  //fakeLogin(state);
                                  login(state);
                                },
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                                : const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
