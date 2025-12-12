// ignore_for_file: public_member_api_docs, sort_constructors_first
// CIF Request Data Class

/*
  @author     : gayathri.b 05/06/2025
 @description: Represents the request payload for the lead search API.
   */
import 'dart:convert';

import 'package:newsee/AppData/app_constants.dart';

class CIFRequest {
  final String? bankName;
  final String? moduleName;
  final String? apiName;
  final String? refNo;
  final String? msgId;
  final String custId;

  CIFRequest({
    this.bankName,
    this.moduleName,
    this.apiName,
    this.refNo,
    this.msgId,
    required this.custId,
  });

  CIFRequest copyWith({
    String? bankName,
    String? moduleName,
    String? apiName,
    String? refNo,
    String? msgId,
    String? custId,
  }) {
    return CIFRequest(
      bankName: bankName ?? AppConstants.bankName,
      moduleName: moduleName ?? AppConstants.mobilityModule,
      apiName: apiName ?? AppConstants.cifApiName,
      refNo: refNo ?? this.refNo,
      msgId: msgId ?? this.msgId,
      custId: custId ?? this.custId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'BankName': bankName,
      'ModuleName': moduleName,
      'ApiName': apiName,
      'RefNo': refNo,
      'msgid': msgId,
      'custId': custId,
    };
  }

  factory CIFRequest.fromMap(Map<String, dynamic> map) {
    return CIFRequest(
      bankName: map['BankName'] as String?,
      moduleName: map['ModuleName'] as String?,
      apiName: map['ApiName'] as String?,
      refNo: map['RefNo'] as String?,
      msgId: map['msgid'] as String?,
      custId: map['custId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CIFRequest.fromJson(String source) =>
      CIFRequest.fromMap(json.decode(source));
}
