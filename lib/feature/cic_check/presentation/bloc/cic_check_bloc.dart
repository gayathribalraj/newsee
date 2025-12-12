import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Utils/shared_preference_utils.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/auth/domain/model/user_details.dart';
import 'package:newsee/feature/cic_check/data/repository/cic_respository_impl.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_report_table_model.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_response_model.dart';
import 'package:newsee/feature/cic_check/domain/modals/cic_request.dart';
import 'package:newsee/feature/cic_check/domain/repository/cibilreports_crud_repo.dart';
import 'package:newsee/feature/cic_check/domain/repository/cic_repository.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_event.dart';
import 'package:newsee/feature/cic_check/presentation/bloc/cic_check_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart';

final class CicCheckBloc extends Bloc<CicCheckEvent, CicCheckState> {
  CicCheckBloc() : super(CicCheckState()) {
    on<CicFetchEvent>(_onSearchCibil);
    on<CibilDataFetchFromDBEvent>(_onGetCibilDataFromTable);
  }

  Future _onGetCibilDataFromTable(
    CibilDataFetchFromDBEvent event,
    Emitter emit,
  ) async {
    try {
      UserDetails? userDetails = await loadUser();
      if (userDetails == null) return null;

      // final db = await DBConfig().database;
      // final cibilCrudRepo = CibilreportsCrudRepo(db);

      // final results = await cibilCrudRepo.getByColumnNames(
      //   columnNames: ['userid', 'proposalNo'],
      //   columnValues: [userDetails.LPuserID, event.proposal],
      // );
      // if (results.isNotEmpty) {
      // print('cibil reports: ${results.length}');
      // final filtered =
      //     results.where((item) {
      //       final mapdata = item.toMap();
      //       return (mapdata['applicantType']?.toString().toLowerCase() ==
      //               'A') &&
      //           (mapdata['reportType']?.toString().toLowerCase() == 'cibil');
      //     }).toList();
      // print(filtered);
      // if (filtered.isNotEmpty) {
      //   final dbdata = filtered.first.toMap();
      if (event.cibilStatu == true) {
        emit(
          state.copyWith(
            // cibilDataFromTable: results,
            // cibilScore: dbdata['cibilScore'] ?? '',
            cibilScore: '830',
          ),
        );
      }
      // }
      // } else {
      //   print('cibil reports: ${results}');
      // }
    } catch (e) {
      print('civilTable: $e');
    }
  }

  Future _onSearchCibil(
    CicFetchEvent event,
    Emitter<CicCheckState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CicCheckStatus.loading));
      UserDetails? userDetails = await loadUser();
      final req = CICRequest(
        proposalNumber: event.proposalData?['propNo'],
        userid: userDetails!.LPuserID,
        customerId: event.proposalData?['borrCustId'],
        orgId: event.proposalData?['branchCode'],
      );
      CicRepository cicRepository = CicRepositoryImpl();
      final response = await cicRepository.searchCibil(req);
      if (response.isRight()) {
        print('response.right: ${response.right}');
        final resp = response.right.toJson();
        bool result = await converHtmlReportDataToFile(
          event.proposalData?['propNo'],
          resp,
          event.applicantType,
          event.reportType,
        );
        if (result == true) {
          emit(
            state.copyWith(
              status: CicCheckStatus.success,
              cibilResponse: response.right,
              cibilScore: resp['cibilScore'],
              isApplicantCibilCheck: true,
            ),
          );
        }
      } else {
        print('cibil failure response.left');
        emit(
          state.copyWith(
            status: CicCheckStatus.failure,
            isApplicantCibilCheck: false,
          ),
        );
      }
    } catch (e) {
      print('Cibil check catch: $e');
      emit(
        state.copyWith(
          status: CicCheckStatus.failure,
          isApplicantCibilCheck: false,
        ),
      );
    }
  }

  converHtmlReportDataToFile(
    String propNo,
    Map<String, dynamic> response,
    String? applicant,
    reportType,
  ) async {
    try {
      UserDetails? userDetails = await loadUser();
      // decode and save base64 html content
      final htmlBase64 = response['htmlFileCIR'];
      if (htmlBase64 != null) {
        final htmlContent = utf8.decode(base64.decode(htmlBase64));

        final dir = await getApplicationDocumentsDirectory();
        final filePath =
            '${dir.path}/${applicant}_${reportType}_${propNo}.html';
        final file = File(filePath);
        await file.writeAsString(htmlContent);

        bool result = await savefilePathInTable({
          'userid': userDetails!.LPuserID,
          'proposalNo': propNo,
          'applicantType': applicant,
          'reportType': reportType,
          'filepath': filePath,
          'cibilScore': response['cibilScore'],
        });
        return result;
      } else {
        throw Exception("htmlBase64 missing in response");
      }
    } catch (e) {
      print('converreporttofile: $e');
      throw Exception('No file created.');
    }
  }

  Future<bool> savefilePathInTable(Map<String, dynamic> data) async {
    try {
      Database db = await DBConfig().database;
      CibilreportsCrudRepo cibilCrudRepo = CibilreportsCrudRepo(db);

      final model = CibilReportTableModel(
        userid: data['userid'],
        proposalNo: data['proposalNo'],
        applicantType: data['applicantType'],
        reportType: data['reportType'],
        filepath: data['filepath'],
        cibilScore: data['cibilScore'],
      );

      await cibilCrudRepo.save(model);

      List<CibilReportTableModel> p = await cibilCrudRepo.getAll();
      print('cibilCrudRepo.getAll() => ${p.length}');
      return true;
    } catch (e) {
      print('savefilePathInTable: $e');
      throw Exception('No file save in db.');
    }
  }
}
