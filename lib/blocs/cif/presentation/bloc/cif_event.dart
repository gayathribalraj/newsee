part of 'cif_bloc.dart';

//create abstract class event extends Equatable

abstract class ChifEvent extends Equatable {
  const ChifEvent();

  @override
  List<Object?> get props => [];
}

//Trigger First Event SearchCif

class SearchCif extends ChifEvent {
  final Map<String, dynamic> request;

  //  create constractor

  const SearchCif({required this.request});

  @override
  List<Object?> get props => [request];
}
