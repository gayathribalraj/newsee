class QueryResponseModal {
  final int proposalNo;
  final bool success;
  final String queryDescription;
  final String queryId;

  QueryResponseModal({
    required this.proposalNo,
    required this.success,
    required this.queryDescription,
    required this.queryId,
  });

  factory QueryResponseModal.fromJson(Map<String, dynamic> json) {
    return QueryResponseModal(
      proposalNo: json['proposalNo'] ?? 0,
      success: json['success'] ?? false,
      queryDescription: json['QueryDescription'] ?? '',
      queryId: json['queryId'] ?? '',
    );
  }
}
