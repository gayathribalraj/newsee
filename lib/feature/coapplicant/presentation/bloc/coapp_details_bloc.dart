/* 
@autor      : karthick.d  20/06/2025
@desc       : bloc for saving co appdetails 
              more than one co-app can be add to co app list 
              co-applicant is optional and will be sent as part of lead details

 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part 'coapp_details_event.dart';
part 'coapp_details_state.dart';

final class CoappDetailsBloc
    extends Bloc<CoappDetailsEvent, CoappDetailsState> {
  CoappDetailsBloc() : super(CoappDetailsState.initial()) {
    on<CoAppDetailsInitEvent>(initCoAppDetailsPage);
    on<CoAppDetailsSaveEvent>(saveCoAppDetailsPage);
  }

  Future<void> initCoAppDetailsPage(
    CoAppDetailsInitEvent event,
    Emitter emit,
  ) async {
    // fetch lov
    Database _db = await DBConfig().database;
    List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
    List<GeographyMaster> stateCityMaster = await GeographymasterCrudRepo(
      _db,
    ).getByColumnNames(
      columnNames: [
        TableKeysGeographyMaster.stateId,
        TableKeysGeographyMaster.cityId,
      ],
      columnValues: ['0', '0'],
    );

    print('listOfLov => $listOfLov');

    emit(state.copyWith(lovList: listOfLov, stateCityMaster: stateCityMaster));
  }

  Future<void> saveCoAppDetailsPage(
    CoAppDetailsSaveEvent event,
    Emitter emit,
  ) async {}
}
