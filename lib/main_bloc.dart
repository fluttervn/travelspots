import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:travelspots/utils/csv_utils.dart';

import 'common/base_bloc.dart';
import 'repos/app_repo.dart';
import 'repos/flt_exception.dart';
import 'repos/models/data_models/relic_data_model.dart';
import 'repos/models/ui_models/relic_ui_model.dart';

/// Business Logic related to Login feature
class MainBloc extends BaseBloc<BaseBlocProperties> {
  /// Provide account data from network or local
  final AppRepo appRepo;
  final SpotDao spotDao;
  List<SpotUIModel> spots = [];

  /// Error message
  String errorMessage = '';

  /// Create instance of AccountBloc, it require repository to get data.
  MainBloc({
    @required this.appRepo,
    @required this.spotDao,
  }) : assert(appRepo != null && spotDao != null);

  @override
  String toString() {
    return 'MainBloc';
  }

  /// Method to call getting Relics
  Future<List<SpotUIModel>> getTravelSpots() async {
    try {
      notifyListeners(BaseBlocProperties.loading);
      /*List<SpotDataModel> relicsData = await appRepo.getTravelSpotList();
      spots = relicsData.map((item) => SpotUIModel.fromData(item)).toList();
      Fimber.d('relic data: ${spots.length} items');*/

      final stopwatch = Stopwatch()..start();
      Fimber.d('~~~ START: Insert to database');
      List<SpotEntity> listSpotEntity =
          await CSVUtils.importDataFromGoogleSheetsForSaigon();
      Fimber.d('~~~ ... with ${listSpotEntity?.length} items');
      spotDao.insertDataFirstTime(listSpotEntity);
      var elapsedTimeMs = stopwatch.elapsed.inMilliseconds;
      Fimber.d('~~~ END: Insert to database SUCCESS: take $elapsedTimeMs ms');

      notifyListeners(BaseBlocProperties.serverSuccess);
      return spots;
    } on FltException catch (e) {
      errorMessage = e.localizeMessage;
      notifyListeners(BaseBlocProperties.serverError);
      rethrow;
    }
  }

  /// Method to call creating Relic
  Future<bool> createTravelSpot(SpotUIModel model) async {
    try {
      notifyListeners(BaseBlocProperties.loading);
      bool result =
          await appRepo.createTravelSpot(data: SpotDataModel.fromUI(model));

      Fimber.d('result: $result');

      notifyListeners(BaseBlocProperties.serverSuccess);
      return result;
    } on FltException catch (e) {
      errorMessage = e.localizeMessage;
      notifyListeners(BaseBlocProperties.serverError);
      rethrow;
    }
  }

  /// Method to test Firestore query
  Future<List<SpotEntity>> findSpotsInRegion({
    @required double latStart,
    @required double latEnd,
    @required double longStart,
    @required double longEnd,
  }) async {
    List<SpotEntity> items =
        await spotDao.findSpotsInRegion(latStart, latEnd, longStart, longEnd);
    Fimber.d('There are ${items?.length} item whenfindSpotsInRegion');
    return items;
  }

  Future checkUpdateData() async {
    print('checkUpdateData');
//    var list = await appRepo.getProvinceMetaList();
//    print('list: $list');

    var localList = appRepo.getOutOfDateProvinces();

//    var list = await appRepo.importGSheetData(
//      '1PmcJMSFHiJo8J1-RALHcV-7pU41xAhabxvw3tnBHi7E',
//      'o2hjwv2',
//      'Hô Chí Minh',
//    );
  }
}
