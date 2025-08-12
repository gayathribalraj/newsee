import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/globalconfig.dart';

part './global_config_state.dart';
part './globalconfig_event.dart';

/* 
@author     : karthick.d 07/10/2025
@desc       : Bloc to maintain global state of Network 

*/
class GlobalConfigBloc extends Bloc<GlobalconfigEvent, NetworkState> {
  GlobalConfigBloc()
    : super(NetworkState(globalconfig: Globalconfig.fromValue())) {
    on<NetworkChangedEvent>(onNetworkChanged);
  }

  Future<void> onNetworkChanged(NetworkChangedEvent ev, Emitter emit) async {
    Globalconfig.isOffline =
        ev.globalConfig.operationNetwork == OperationNetwork.offline;
    emit(NetworkState(globalconfig: ev.globalConfig));
  }
}
