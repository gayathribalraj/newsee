import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';

enum SchemeType {
  shg,
  jlg,
  base,
}
SchemeType resolveSchemeTypeFromLoan(LoanproductState state) {
  final schema = state.selectedProductScheme;

  if (schema == null) return SchemeType.base;

  final value = schema.optionDesc.toUpperCase();

  if (value.contains('SHG')) {
    return SchemeType.shg;
  } else if (value.contains('JOINT LIABILITY') || value.contains('JLG')) {
    return SchemeType.jlg;
  } else {
    return SchemeType.base;
  }
}
