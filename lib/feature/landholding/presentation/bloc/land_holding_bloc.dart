import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/feature/landholding/data/repository/land_Holding_respository_impl.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';
import 'package:newsee/feature/leadInbox/data/repository/lead_respository_impl.dart';
import 'package:newsee/feature/leadInbox/domain/modal/group_lead_inbox.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_responce_model.dart';
import 'package:newsee/feature/leadInbox/domain/repository/lead_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/feature/landholding/domain/modal/group_land_Holding.dart';
import 'package:newsee/feature/landholding/domain/modal/land_Holding_request.dart';
import 'package:equatable/equatable.dart';
import 'package:newsee/feature/landholding/domain/modal/group_land_Holding.dart';

part 'land_holding_event.dart';
part 'land_holding_state.dart';

class LeadBloc extends Bloc<LandHoldingEvent, LandHoldingState> {
  final LandHoldingRepository landHoldingRepository;

  LeadBloc({LeadRepository? repository})
    : landHoldingRepository = repository ?? LandHoldingRepositoryImpl(),
      super(LandHoldingState()) {
    on<FetchlandholdingEvent>(onFetchLand);
  }

  Future<void> onFetchLand(
    FetchlandholdingEvent event,
    Emitter<LandHoldingState> emit,
  ) async {
    emit(state.copyWith(status: LandHoldingStatus.loading));

    final response = await landHoldingRepository.landHolding(event.request);
    // check if response i success and contains valid data , success status is emitted

    if (response.isRight()) {
      emit(
        state.copyWith(
          status: LandHoldingStatus.success,
          leadHoldingResponseModel: response.right
        ),
      );
    } else {
      print('Lead failure response.left');
      emit(
        state.copyWith(
          status: LandHoldingState.,
          errorMessage: response.left.message,
        ),
      );
    }
  }
}
