part of 'land_holding_bloc.dart';

abstract class LandHoldingEvent {
  const LandHoldingEvent();
}
// bloc event type that will be called when Login button clicked

class FetchlandholdingEvent extends LandHoldingEvent {
  final LandHoldingRequest request;

  const FetchlandholdingEvent({required this.request});

  @override
  List<Object?> get props => [request];
}
