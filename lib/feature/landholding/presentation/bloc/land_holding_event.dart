part of 'land_holding_bloc.dart';

abstract class LandHoldingEvent extends Equatable {
  const LandHoldingEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialLandHolding extends LandHoldingEvent {}

class SubmitLandHoldingForm extends LandHoldingEvent {
  final LandHoldingRequest request;

  const SubmitLandHoldingForm(this.request);

  @override
  List<Object?> get props => [request];
}
