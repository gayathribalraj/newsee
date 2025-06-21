import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';

part 'land_holding_event.dart';
part 'land_holding_state.dart';

final class LandHoldingBloc extends Bloc<LandHoldingEvent, LandHoldingState> {
  LandHoldingBloc() : super(LandHoldingState.init()) {
    on<LandDetailsSaveEvent>(_onSubmit);
    on<LandDetailsLoadEvent>(_onLoad);
  }

  /// Save new land data
  Future<void> _onSubmit(
    LandDetailsSaveEvent event,
    Emitter<LandHoldingState> emit,
  ) async {
    final newList = [...?state.landData, event.landData];
    emit(
      state.copyWith(
        status: SaveState.success,
        landData: newList,
        selectedLandData: null, // Optional: clear selected after save
      ),
    );
  }

  /// Load data into form for editing
  void _onLoad(LandDetailsLoadEvent event, Emitter<LandHoldingState> emit) {
    emit(state.copyWith(selectedLandData: event.landData));
  }
}
