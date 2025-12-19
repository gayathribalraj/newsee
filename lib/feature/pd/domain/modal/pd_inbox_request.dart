// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/*
  @author     : karthick.d 12/06/2025
 @description: Represents the request payload for the pd inbox .
   */
class PdInboxRequest {
  String userId;
  String token;
  int pageNo;
  int pageCount;
  List<String> orgId;
  PdInboxRequest({
    required this.userId,
    required this.token,
    this.pageNo = 0,
    this.pageCount = 20,
    this.orgId = const ["14356"],
  });

  PdInboxRequest copyWith({
    String? userid,
    String? token,
    int? pageNo,
    int? pageCount,
    List<String>? orgId,
  }) {
    return PdInboxRequest(
      userId: userId ?? userId,
      token: token ?? this.token,
      pageNo: pageNo ?? this.pageNo,
      pageCount: pageCount ?? this.pageCount,
      orgId: orgId ?? this.orgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'token': token,
      'pageNo': pageNo,
      'pageCount': pageCount,
      'orgId': orgId,
    };
  }

  factory PdInboxRequest.fromMap(Map<String, dynamic> map) {
    return PdInboxRequest(
      userId: map['userId'] as String,
      token: map['token'] as String,
      pageNo: map['pageNo'] as int,
      pageCount: map['pageCount'] as int,
      orgId: List<String>.from((map['orgId'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory PdInboxRequest.fromJson(String source) =>
      PdInboxRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PdInboxRequest(userId: $userId, token: $token, pageNo: $pageNo, pageCount: $pageCount , orgId: $orgId )';
  }

  @override
  bool operator ==(covariant PdInboxRequest other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.token == token &&
        other.pageNo == pageNo &&
        other.pageCount == pageCount &&
        other.orgId == orgId;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        token.hashCode ^
        pageNo.hashCode ^
        pageCount.hashCode ^
        orgId.hashCode;
  }
}
