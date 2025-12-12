class QueryRequestModal {
  final String queryId;
  final String propNo;
  final String recipient;
  final String tocC;

  QueryRequestModal({
    required this.queryId,
    required this.propNo,
    required this.recipient,
    required this.tocC,
  });

  Map<String, dynamic> toJson() {
    return {
      "queryId": queryId,
      "propNo": propNo,
      "recipient": recipient,
      "TOCc": tocC,
    };
  }
}
