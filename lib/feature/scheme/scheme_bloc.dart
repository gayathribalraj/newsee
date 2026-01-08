import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/scheme/scheme_event.dart';
import 'package:newsee/feature/scheme/scheme_state.dart';
import 'package:newsee/feature/scheme/widget/scheme_type.dart';

class SchemeBloc extends Bloc<SchemeEvent, SchemeState> {
  SchemeBloc() : super(const SchemeState(selectedScheme: SchemeType.base)) {
    on<SelectSchemeEvent>((event, emit) {
      emit(state.copyWith(selectedScheme: event.scheme));
    });
  }
}
