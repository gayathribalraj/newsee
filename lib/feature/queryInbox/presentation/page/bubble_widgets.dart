import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

Widget buildImageFileBubble(TextMessage msg, {required VoidCallback onTap}) {
  String dt = msg.createdAt.toString();

  List parts = dt.split(" ");
  String date = parts[0];
  String time = parts[1].substring(0, 5);
  String dtTm = "$date $time";
  return GestureDetector(
    onTap: onTap,
    child: Container(
      constraints: BoxConstraints(maxWidth: 220),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  msg.text,
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 6),

          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              dtTm,
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildPdfBubble(TextMessage msg, {required VoidCallback onTap}) {
  String dt = msg.createdAt.toString();

  List parts = dt.split(" ");
  String date = parts[0];
  String time = parts[1].substring(0, 5);
  String dtTm = "$date $time";
  return GestureDetector(
    onTap: onTap,
    child: Container(
      constraints: BoxConstraints(maxWidth: 220),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red),
              SizedBox(width: 8),
              Text(msg.text, style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 6),
            ],
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              dtTm,
              style: TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildDocBubble(TextMessage msg, {required VoidCallback onTap}) {
  return Container(
    margin: EdgeInsets.all(8),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.description, color: Colors.blue),
        SizedBox(width: 8),
        // Text(msg.text),
      ],
    ),
  );
}
