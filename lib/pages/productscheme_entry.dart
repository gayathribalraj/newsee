import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newsee/feature/masters/domain/modal/productschema.dart';
import 'package:newsee/feature/schemes/scheme_bloc.dart';
import 'package:newsee/feature/schemes/scheme_state.dart';
import 'package:newsee/feature/schemes/scheme_type.dart';
import 'package:newsee/pages/other_personal.dart';
import 'package:newsee/pages/personal.dart';

class PersonalEntryPage extends StatelessWidget {
  const PersonalEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchemeBloc, SchemeState>(
      builder: (context, state) {
        print('here bro...${state.selectedScheme}');
        switch (state.selectedScheme) {
          case SchemeType.shg:
            return Personal(title: "SHG Personal");

          case SchemeType.jlg:
            return Personal(title: "JLG Personal");

          case SchemeType.other:
            return Personal(title: "Other Personal");
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
    return SchemeType.other;
  }
}
