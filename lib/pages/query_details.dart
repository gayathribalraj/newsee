/*
 @author     : Gayathri B
   @date       : 02/12/2025
   @desc       : Query Details page displaying chat conversation.
                Shows chat messages between user and support staff with message input.
 */

import 'package:flutter/material.dart';
import 'package:newsee/widgets/chat_widget.dart';

class QueryDetails extends StatelessWidget {
  final String userName;
  final String queryType;

  const QueryDetails({
    Key? key,
    required this.userName,
    required this.queryType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatWidget(userName: userName, queryType: queryType);
  }
}

