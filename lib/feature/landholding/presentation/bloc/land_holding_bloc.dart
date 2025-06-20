import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:newsee/feature/landholding/data/repository/land_Holding_respository_impl.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';

import 'package:newsee/feature/landholding/domain/modal/group_land_Holding.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';

part 'land_holding_event.dart';
part 'land_holding_state.dart';

class LandHoldingBloc extends Bloc<LandHoldingEvent, LandHoldingState> {
  final LandHoldingRepository repository;

  LandHoldingBloc({required this.repository}) : super(LandHoldingInitial()) {
    on<LoadInitialLandHolding>((event, emit) async {
      emit(LandHoldingLoading());
      await Future.delayed(Duration(seconds: 1)); 
      emit(LandHoldingLoaded());
    });

    on<SubmitLandHoldingForm>((event, emit) async {
      emit(LandHoldingSubmitting());
      try {
        await repository.submitLandHolding(event.request);
        emit(LandHoldingSuccess());
      } catch (e) {
        emit(LandHoldingFailure(e.toString()));
      }
    });
  }
}
