import 'package:flutter/material.dart';
import 'package:newsee/feature/queryInbox/presentation/page/chat_widget.dart';

class QueryDetails extends StatelessWidget {
  final String userName;
  final String queryType;
  final String queryId;
  final num proposalNo;
  final String status;
  const QueryDetails({
    super.key,
    required this.userName,
    required this.queryType,
    required this.queryId,
    required this.proposalNo,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ChatWidget(
      userName: userName,
      queryType: queryType,
      queryId: queryId,
      proposalNo: proposalNo,
      status: status,
    );
  }
}
