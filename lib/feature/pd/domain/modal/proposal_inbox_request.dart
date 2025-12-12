import 'dart:convert';

class ProposalInboxRequest {
  String userid;
  String? token;

  ProposalInboxRequest({required this.userid, this.token});

  ProposalInboxRequest copyWith({String? userid, String? token}) {
    return ProposalInboxRequest(
      userid: userid ?? this.userid,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {'userid': userid, 'token': token};
  }

  factory ProposalInboxRequest.fromMap(Map<String, dynamic> map) {
    return ProposalInboxRequest(
      userid: map['userid'] as String,
      token: map['token'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProposalInboxRequest.fromJson(String source) =>
      ProposalInboxRequest.fromMap(json.decode(source));
}
