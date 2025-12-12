import 'package:equatable/equatable.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_report_table_model.dart';
import 'package:newsee/feature/cic_check/domain/modals/cibil_response_model.dart';

enum CicCheckStatus { initial, loading, success, failure }

class CicCheckState extends Equatable {
  final CicCheckStatus? status;
  final CibilResponse? cibilResponse;
  final bool isApplicantCibilCheck;
  final bool? isCoAppCibilCheck;
  final List<CibilReportTableModel>? cibilDataFromTable;
  final String? cibilScore;

  const CicCheckState({
    this.status,
    this.cibilResponse,
    this.isApplicantCibilCheck = false,
    this.isCoAppCibilCheck = false,
    this.cibilDataFromTable,
    this.cibilScore,
  });

  factory CicCheckState.init() => CicCheckState(status: CicCheckStatus.initial);

  CicCheckState copyWith({
    CicCheckStatus? status,
    CibilResponse? cibilResponse,
    bool? isApplicantCibilCheck,
    bool? isCoAppCibilCheck,
    String? cibilScore,
    List<CibilReportTableModel>? cibilDataFromTable,
  }) {
    return CicCheckState(
      status: status ?? this.status,
      cibilResponse: cibilResponse ?? this.cibilResponse,
      isApplicantCibilCheck:
          isApplicantCibilCheck ?? this.isApplicantCibilCheck,
      isCoAppCibilCheck: isCoAppCibilCheck ?? this.isCoAppCibilCheck,
      cibilDataFromTable: cibilDataFromTable ?? this.cibilDataFromTable,
      cibilScore: cibilScore ?? this.cibilScore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cibilResponse,
    isApplicantCibilCheck,
    isCoAppCibilCheck,
    cibilDataFromTable,
    cibilScore,
  ];
}
