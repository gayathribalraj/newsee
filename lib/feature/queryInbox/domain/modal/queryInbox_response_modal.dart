class QueryInboxResponseModal {
  final bool success;
  final List<QueryItem> queryList;

  QueryInboxResponseModal({required this.success, required this.queryList});

  factory QueryInboxResponseModal.fromJson(Map<String, dynamic> json) {
    return QueryInboxResponseModal(
      success: json['Success'] ?? false,
      queryList:
          (json['queryList'] as List<dynamic>? ?? [])
              .map((e) => QueryItem.fromJson(e))
              .toList(),
    );
  }
}

class QueryItem {
  final num proposalNo;
  final String senderName;
  final String subject;
  final String queryId;
  final DateTime date;
  final String status;

  QueryItem({
    required this.proposalNo,
    required this.senderName,
    required this.subject,
    required this.queryId,
    required this.date,
    required this.status,
  });

  factory QueryItem.fromJson(Map<String, dynamic> json) {
    return QueryItem(
      proposalNo: json['proposalNo'],
      senderName: json['senderName'] ?? '',
      subject: json['Subject'] ?? '',
      queryId: json['queryId'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "proposalNo": proposalNo,
      "senderName": senderName,
      "Subject": subject,
      "queryId": queryId,
      "date": date,
      "status": status,
    };
  }
}
