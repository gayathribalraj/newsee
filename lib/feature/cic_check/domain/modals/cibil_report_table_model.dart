// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'cibil_report_table_model.g.dart';

@JsonSerializable()
class CibilReportTableModel {
  final String userid;
  final String proposalNo;
  final String applicantType;
  final String reportType;
  final String filepath;
  final String cibilScore;
  CibilReportTableModel({
    required this.userid,
    required this.proposalNo,
    required this.applicantType,
    required this.reportType,
    required this.filepath,
    required this.cibilScore,
  });

  CibilReportTableModel copyWith({
    String? userid,
    String? proposalNo,
    String? applicantType,
    String? reportType,
    String? filepath,
    String? cibilScore,
  }) {
    return CibilReportTableModel(
      userid: userid ?? this.userid,
      proposalNo: proposalNo ?? this.proposalNo,
      applicantType: applicantType ?? this.applicantType,
      reportType: reportType ?? this.reportType,
      filepath: filepath ?? this.filepath,
      cibilScore: cibilScore ?? this.cibilScore,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userid': userid,
      'proposalNo': proposalNo,
      'applicantType': applicantType,
      'reportType': reportType,
      'filepath': filepath,
      'cibilScore': cibilScore,
    };
  }

  factory CibilReportTableModel.fromMap(Map<String, dynamic> map) {
    return CibilReportTableModel(
      userid: map['userid'] as String,
      proposalNo: map['proposalNo'] as String,
      applicantType: map['applicantType'] as String,
      reportType: map['reportType'] as String,
      filepath: map['filepath'] as String,
      cibilScore: map['cibilScore'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$CibilReportTableModelToJson(this);

  factory CibilReportTableModel.fromJson(Map<String, dynamic> json) =>
      _$CibilReportTableModelFromJson(json);

  @override
  String toString() {
    return 'CibilReportTableModel(userid: $userid, proposalNo: $proposalNo, applicantType: $applicantType, reportType: $reportType, filepath: $filepath, cibilScore: $cibilScore)';
  }

  @override
  int get hashCode {
    return userid.hashCode ^
        proposalNo.hashCode ^
        applicantType.hashCode ^
        reportType.hashCode ^
        filepath.hashCode ^
        cibilScore.hashCode;
  }
}
