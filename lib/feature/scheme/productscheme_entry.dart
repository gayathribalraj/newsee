import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/loanproductdetails/presentation/bloc/loanproduct_bloc.dart';

import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/feature/scheme/pages/base_form.dart';
import 'package:newsee/feature/scheme/pages/jlg_form.dart';
import 'package:newsee/feature/scheme/pages/shg_form.dart';
import 'package:newsee/feature/scheme/widget/scheme_type.dart';

class PersonalEntryPage extends StatelessWidget {
  const PersonalEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanproductBloc, LoanproductState>(
      builder: (context, loanState) {
        final schemeType = resolveSchemeTypeFromLoan(loanState);

        switch (schemeType) {
          case SchemeType.shg:
            return ShgForm(title: "SHG Personal");

          case SchemeType.jlg:
            return JlgForm(title: "JLG Personal");

          case SchemeType.base:
          // default:
            return BaseForm(title: "Base Personal");
        }
      },
    );
  }
}


SchemeType mapToSchemeType(ProductSchema schema) {
  final value = schema.optionDesc.toUpperCase();
  print('Mapping scheme type for optionDesc: $value');
  if (value.contains('SHG')) {
    return SchemeType.shg;
  } else if (value.contains('JOINT LIABILITY GROUP')) {
    return SchemeType.jlg;
  } else {
    return SchemeType.base;
  }
}
