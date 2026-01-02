import 'package:flutter/material.dart';

class CreditScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Credit Score", style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(child: Icon(Icons.person)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
    );
  }
}
