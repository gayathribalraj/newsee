part of 'land_holding_bloc.dart';

enum LandHoldingStatus { initial, loading, success, failure }
// we need following state status which is defines http init , loading
// success and failure

class LandHoldingState extends Equatable {
  final LandHoldingStatus status;
  final List<GroupLandHolding>? landHoldingResponseModel;
  final String? errorMessage;

  const LandHoldingState({
    this.status = LandHoldingStatus.initial,
    this.landHoldingResponseModel,
    this.errorMessage,
  });

  factory LandHoldingState.init() => const LandHoldingState();

  LandHoldingState copyWith({
    LandHoldingStatus? status,
    List<GroupLandHolding>? leadHoldingResponseModel,
    String? errorMessage,
  }) {
    return LandHoldingState(
      status: status ?? this.status,
      landHoldingResponseModel:
          leadHoldingResponseModel ?? this.landHoldingResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, landHoldingResponseModel, errorMessage];
}
