import 'package:flutter/material.dart';
import 'package:newsee/timer/timer.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer - BLoC',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Color.fromRGBO(72, 74, 126, 1)),
      ),
      home: const TimerPage(),
    );
  }
}
