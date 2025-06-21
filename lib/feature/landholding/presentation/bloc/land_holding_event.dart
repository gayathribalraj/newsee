part of 'land_holding_bloc.dart';

abstract class LandHoldingEvent extends Equatable {
  const LandHoldingEvent();

  @override
  List<Object?> get props => [];
}

class LoadInitialLandHolding extends LandHoldingEvent {
  const LoadInitialLandHolding();
}

class LandDetailsSaveEvent extends LandHoldingEvent {
  final Landdata landData;

  const LandDetailsSaveEvent({required this.landData});

  @override
  List<Object?> get props => [landData];
}

class LandDetailsLoadEvent extends LandHoldingEvent {
  final Landdata landData;

  const LandDetailsLoadEvent({required this.landData});

  @override
  List<Object?> get props => [landData];
}
