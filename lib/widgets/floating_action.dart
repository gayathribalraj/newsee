import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FloatingActionBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.goNamed('newlead');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Floating Action Button Pressed")),
        // );
      },
      backgroundColor: Colors.white,
      child: Icon(Icons.add, color: Colors.black),
    );
  }
}
