import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/offline_data_provider.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_report_table_model.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_bloc.dart';
import 'package:newsee/widgets/cibil_html_viewer.dart';
import 'package:newsee/widgets/sysmo_alert.dart';

Future<void> viewCibilHtml(
  BuildContext context,
  String? proposalNum,
  String? applicantType,
  String? report,
  List<CibilReportTableModel>? cibilReportTableData,
) async {
  try {
    final bloc = context.read<CicCheckBloc>();
    String htmlBase64 = bloc.state.cibilResponse?.htmlFileCIR ?? '';
    String? localFilePath;

    if (htmlBase64.isEmpty) {
      // if (cibilReportTableData != null && cibilReportTableData.isNotEmpty) {
      //   final filtered =
      //       cibilReportTableData.where((item) {
      //         final mapdata = item.toMap();
      //         return (mapdata['applicantType']?.toString().toLowerCase() ==
      //                 applicantType?.toLowerCase()) &&
      //             (mapdata['reportType']?.toString().toLowerCase() ==
      //                 report?.toLowerCase());
      //       }).toList();
      // if (cibilReportTableData != null && cibilReportTableData.isNotEmpty) {
      //   final filtered =
      //       cibilReportTableData.where((item) {
      //         final mapdata = item.toMap();
      //         return (mapdata['applicantType']?.toString().toLowerCase() ==
      //                 applicantType?.toLowerCase()) &&
      //             (mapdata['reportType']?.toString().toLowerCase() ==
      //                 report?.toLowerCase());
      //       }).toList();

      //   if (filtered.isNotEmpty) {
      //     final dbdata = filtered.first.toMap();
      //     localFilePath = dbdata['filepath'] ?? '';
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('No matching report found')),
      //     );
      //     return;
      //   }
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('No report found in database')),
      //   );
      //   return;
      // }

      final response = await offlineDataProvider(
        path: AppConstants.cibilResponsonse,
      );
      final data = response.data;
      final responseString = data[ApiConfig.API_RESPONSE_KEY] ?? '{}';
      final responseJson = json.decode(responseString);
      htmlBase64 = responseJson['htmlFileCIR'];
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CibilHtmlViewer(
              htmlFileBase64: htmlBase64,
              propNo: proposalNum,
              applicantType: applicantType,
              reportType: report,
              localFilePath: localFilePath,
            ),
      ),
    );
  } catch (e) {
    print('Error loading cibil html: $e');

    showDialog(
      context: context,
      builder:
          (_) => SysmoAlert(
            message: AppConstants.FAILED_TO_LOAD_PDF_MESSAGE,
            icon: Icons.error_outline,
            iconColor: Colors.red,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            buttonText: AppConstants.OK,
            onButtonPressed: () => Navigator.pop(context),
          ),
    );
  }
}

// Future<List<dynamic>?> fetchReportsFromDB(String proposalNum) async {
//   UserDetails? userDetails = await loadUser();
//   if (userDetails == null) return null;
// Future<List<dynamic>?> fetchReportsFromDB(String proposalNum) async {
//   UserDetails? userDetails = await loadUser();
//   if (userDetails == null) return null;

//   final db = await DBConfig().database;
//   final cibilCrudRepo = CibilreportsCrudRepo(db);
//   final db = await DBConfig().database;
//   final cibilCrudRepo = CibilreportsCrudRepo(db);

//   final results = await cibilCrudRepo.getByColumnNames(
//     columnNames: ['userid', 'proposalNo'],
//     columnValues: [userDetails.LPuserID, proposalNum],
//   );

//   print('cibil reports: ${results.length}');
//   return results;
// }
