part of 'global_config_bloc.dart';

/*
@author    : karthick.d  07/10/2025
@desc      : events for GlobalConfigBloc

*/
sealed class GlobalconfigEvent {
  final Globalconfig globalConfig;
  GlobalconfigEvent(this.globalConfig);
}

final class NetworkChangedEvent extends GlobalconfigEvent {
  NetworkChangedEvent(super.globalConfig);
}
