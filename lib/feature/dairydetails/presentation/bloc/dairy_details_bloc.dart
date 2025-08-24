import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/feature/dairydetails/presentation/bloc/dairy_details_state.dart';
import 'package:newsee/feature/dairydetails/presentation/bloc/dairy_details_event.dart';


class DairyDetailsBloc extends Bloc<DairyDetailsEvent, DairyDetailsState> {
  DairyDetailsBloc() : super(const DairyDetailsState()) {
    on<AddDetails>((event, emit) async {
      emit(state.copyWith(status: DairyDetailsStatus.loading));
      try {
        final updated = List<Map<String, dynamic>>.from(state.addedDetails)
          ..add(event.detail);
        emit(state.copyWith(addedDetails: updated, status: DairyDetailsStatus.success, error: null));
      } catch (e) {
        emit(state.copyWith(status: DairyDetailsStatus.failure, error: e.toString()));
      }
    });

    on<DeleteDetails>((event, emit) async {
      emit(state.copyWith(status: DairyDetailsStatus.loading));
      try {
        final updated = List<Map<String, dynamic>>.from(state.addedDetails)
          ..removeAt(event.index);
        emit(state.copyWith(addedDetails: updated, status: DairyDetailsStatus.success, error: null));
      } catch (e) {
        emit(state.copyWith(status: DairyDetailsStatus.failure, error: e.toString()));
      }
    });

    on<DairyDetailsFailed>((event, emit) {
      emit(state.copyWith(status: DairyDetailsStatus.failure, error: event.error));
    });
  }
}
