import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// declare the contact pharam

void contact(
  BuildContext context,
  String title,
  String number1,
  String number2,
  IconData icon,
) {
  // popup the bottom sheet

  showCupertinoModalPopup<void>(
    context: context,
    builder:
        (BuildContext context) => CupertinoActionSheet(
          title: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          actions:<CupertinoActionSheetAction> [
            
          
                CupertinoActionSheetAction(
                  onPressed: () {
                    // print(number1);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        number1,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Icon(
                        icon,
                        color: const Color.fromARGB(255, 32, 219, 35),
                        size: 30,
                      ),
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        number2,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Icon(
                        icon,
                        color: const Color.fromARGB(255, 32, 219, 35),
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        
      
  );
}
