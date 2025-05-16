import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void forgetActionSheet(
  BuildContext context,
  String title,
  String message,
  IconData icon,
  String action1, 
  String action2, 
) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Column(
        children: [
          Icon(icon, size: 50, color: const Color.fromARGB(255, 3, 9, 110)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      message: Text(
        message,
        style: const TextStyle(fontSize: 16, color: CupertinoColors.black),
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(action2), 
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(action1), 
        ),
      ],
    ),
  );
}
