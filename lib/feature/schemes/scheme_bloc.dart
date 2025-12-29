import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/form_builders.dart';
import 'package:newsee/feature/schemes/scheme_event.dart';
import 'package:newsee/feature/schemes/scheme_state.dart';
import 'package:newsee/feature/schemes/scheme_type.dart';

class SchemeBloc extends Bloc<SchemeEvent, SchemeState> {
  SchemeBloc() : super(const SchemeState(selectedScheme: SchemeType.other)) {
    on<SelectSchemeEvent>((event, emit) {
      emit(state.copyWith(selectedScheme: event.scheme));
      // Automatically initialize form when scheme is selected
      add(InitializeSchemeFormEvent(event.scheme));
    });

    on<InitializeSchemeFormEvent>((event, emit) {
      final form = FormBuilders.getFormForScheme(_getSchemeLabel(event.scheme));
      emit(state.copyWith(
        selectedScheme: event.scheme,
        dynamicForm: form,
        formType: _getSchemeLabel(event.scheme),
      ));
    });
  }

  String _getSchemeLabel(SchemeType schemeType) {
    switch (schemeType) {
      case SchemeType.shg:
        return 'SHG';
      case SchemeType.jlg:
        return 'JLG';
      case SchemeType.other:
        return 'OTHER';
    }
  }
}
