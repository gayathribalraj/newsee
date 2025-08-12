// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'global_config_bloc.dart';

/*
@author    :  karthick.d  07/10/2025
@desc      :  state object for maintain offline ,online network state

*/
abstract class GlobalConfigState extends Equatable {
  final Globalconfig globalconfig;
  GlobalConfigState({required this.globalconfig});
  @override
  // TODO: implement props
  List<Object?> get props => [globalconfig];
}

class NetworkState extends GlobalConfigState {
  NetworkState({required super.globalconfig});
}
