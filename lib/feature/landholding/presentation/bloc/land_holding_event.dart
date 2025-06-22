part of 'land_holding_bloc.dart';

abstract class LandHoldingEvent extends Equatable {
  const LandHoldingEvent();

  @override
  List<Object?> get props => [];
}

class LandHoldingInitEvent extends LandHoldingEvent {}

class LandDetailsSaveEvent extends LandHoldingEvent {
  final LandData landData;

  const LandDetailsSaveEvent({required this.landData});

  @override
  List<Object?> get props => [landData];
}

class LandDetailsLoadEvent extends LandHoldingEvent {
  final LandData landData;

  const LandDetailsLoadEvent({required this.landData});

  @override
  List<Object?> get props => [landData];
}
