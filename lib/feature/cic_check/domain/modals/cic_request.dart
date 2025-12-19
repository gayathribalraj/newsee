// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:newsee/core/api/api_config.dart';

class CICRequest extends Equatable {
  final String? proposalNumber;
  final String? customerId;
  final String? userid;
  final String? orgId;
  final String? vertical;
  final String? token;

  const CICRequest({
    this.proposalNumber,
    this.customerId,
    this.userid,
    this.orgId,
    this.vertical = ApiConfig.VERTICAL,
    this.token = ApiConfig.AUTH_TOKEN,
  });

  CICRequest copyWith({
    String? proposalNumber,
    String? customerId,
    String? userid,
    String? orgId,
    String? vertical,
    String? token,
  }) {
    return CICRequest(
      proposalNumber: proposalNumber ?? this.proposalNumber,
      customerId: customerId ?? this.customerId,
      userid: userid ?? this.userid,
      orgId: orgId ?? this.orgId,
      vertical: vertical ?? this.vertical,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'proposalNumber': proposalNumber,
      'customerId': customerId,
      'userid': userid,
      'orgId': orgId,
      'vertical': vertical,
      'token': token,
    };
  }

  factory CICRequest.fromMap(Map<String, dynamic> map) {
    return CICRequest(
      proposalNumber: map['proposalNumber'],
      customerId: map['customerId'],
      userid: map['userid'],
      orgId: map['orgId'],
      vertical: map['vertical'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CICRequest.fromJson(String source) =>
      CICRequest.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    proposalNumber,
    customerId,
    userid,
    orgId,
    vertical,
    token,
  ];
}
