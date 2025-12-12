class QueryInboxRequestModal {
  final String userId;

  QueryInboxRequestModal({required this.userId});

  Map<String, dynamic> toJson() => {"userId": userId};
}
