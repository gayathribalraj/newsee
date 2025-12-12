// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cibil_report_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CibilReportTableModel _$CibilReportTableModelFromJson(
  Map<String, dynamic> json,
) => CibilReportTableModel(
  userid: json['userid'] as String,
  proposalNo: json['proposalNo'] as String,
  applicantType: json['applicantType'] as String,
  reportType: json['reportType'] as String,
  filepath: json['filepath'] as String,
  cibilScore: json['cibilScore'] as String,
);

Map<String, dynamic> _$CibilReportTableModelToJson(
  CibilReportTableModel instance,
) => <String, dynamic>{
  'userid': instance.userid,
  'proposalNo': instance.proposalNo,
  'applicantType': instance.applicantType,
  'reportType': instance.reportType,
  'filepath': instance.filepath,
  'cibilScore': instance.cibilScore,
};
