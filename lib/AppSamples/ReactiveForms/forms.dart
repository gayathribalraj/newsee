/* 

Simple login form app using reactive_form library 

Using BLoC for state management 

 */

import 'package:flutter/material.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/loginpage_view.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: LoginpageView()));
  }
}
