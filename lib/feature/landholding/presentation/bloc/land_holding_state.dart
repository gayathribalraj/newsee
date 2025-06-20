part of 'land_holding_bloc.dart';

abstract class LandHoldingState extends Equatable {
  const LandHoldingState();

  @override
  List<Object?> get props => [];
}

class LandHoldingInitial extends LandHoldingState {}

class LandHoldingLoading extends LandHoldingState {}

class LandHoldingLoaded extends LandHoldingState {}

class LandHoldingSubmitting extends LandHoldingState {}

class LandHoldingSuccess extends LandHoldingState {}

class LandHoldingFailure extends LandHoldingState {
  final String message;

  const LandHoldingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
