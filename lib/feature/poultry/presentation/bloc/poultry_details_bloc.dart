import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/feature/poultry/presentation/bloc/poultry_details_event.dart';
import 'package:newsee/feature/poultry/presentation/bloc/poultry_details_state.dart';
import 'package:reactive_forms/reactive_forms.dart';



class PoultryBloc extends Bloc<PoultryEvent, PoultryState> {
  PoultryBloc() : super(PoultryState.initial()) {
    on<AddPoultryDetails>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.addedDetails)
        ..add(event.details);
      emit(state.copyWith(addedDetails: updatedList));
    });

    on<RemovePoultryDetails>((event, emit) {
      final updatedList = List<Map<String, dynamic>>.from(state.addedDetails)
        ..removeAt(event.index);
      emit(state.copyWith(addedDetails: updatedList));
    });

    on<PatchPoultryForm>((event, emit) {
      event.form.patchValue(event.details);
    });
  }
}
