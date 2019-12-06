import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:travelspots/common/base_bloc.dart';
import 'package:travelspots/repos/app_repo.dart';
import 'package:travelspots/repos/flt_exception.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:travelspots/repos/models/ui_models/spot_ui_model.dart';
import 'package:travelspots/utils/csv_utils.dart';

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

//  /// Method to call creating Relic
//  Future<bool> createTravelSpot(SpotUIModel model) async {
//    try {
//      notifyListeners(BaseBlocProperties.loading);
//      bool result =
//          await appRepo.createTravelSpot(data: SpotDataModel.fromUI(model));
//
//      Fimber.d('result: $result');
//
//      notifyListeners(BaseBlocProperties.serverSuccess);
//      return result;
//    } on FltException catch (e) {
//      errorMessage = e.localizeMessage;
//      notifyListeners(BaseBlocProperties.serverError);
//      rethrow;
//    }
//  }

  /// Method to test Firestore query
  Future<List<SpotEntity>> findSpotsInRegion({
    @required double latStart,
    @required double latEnd,
    @required double longStart,
    @required double longEnd,
    @required int popularity,
  }) async {
    List<SpotEntity> items = await spotDao.findSpotsInRegion(
      latStart,
      latEnd,
      longStart,
      longEnd,
      popularity,
    );
    Fimber.d('There are ${items?.length} item whenfindSpotsInRegion with '
        'popularity=$popularity');
    return items;
  }

  Future checkUpdateData() async {
    print('checkUpdateData');
//    var list = await appRepo.getProvinceMetaList();
//    print('list: $list');

    try {
      ProvinceMetaData provinceMetaData = await appRepo.getOutOfDateProvinces();
      var outOfDateList = provinceMetaData.outOfDateList;
      print('Out of date provinces are: $outOfDateList');

      if (outOfDateList != null && outOfDateList.isNotEmpty) {
        print('Fetching new data of ${outOfDateList.length} provinces');
        List<Future<List<SpotEntity>>> tasks = [];
        outOfDateList.forEach((province) {
          tasks.add(appRepo.importGSheetData(
            province.spreadsheetId,
            province.worksheetId,
            province.provinceName,
          ));
        });
        List<List<SpotEntity>> data = await Future.wait(tasks);
        print('Update multiple ${data?.length} provinces DONE: ');

        List<SpotEntity> fullData = [];
        data.forEach((item) => fullData.addAll(item));
        print('Total SpotEntity is: ${fullData.length} items');

        Map<String, int> localIdTimeAll = provinceMetaData.localIdTimeAll;
        List<String> uniqueKeys = [];
        outOfDateList.forEach((item) {
          uniqueKeys.add(item.uniqueKey);
        });

        print('List of out-of-date uniqueKeys: $uniqueKeys');

        await appRepo.updateTravelSpotList(
          spotList: fullData,
          uniqueKeys: uniqueKeys,
        );
        await appRepo.setProvinceMetaList(localIdTimeAll);
      }
    } on FltException catch (e) {
      print('checkUpdateData err: $e');
    }

//    var list = await appRepo.importGSheetData(
//      '1PmcJMSFHiJo8J1-RALHcV-7pU41xAhabxvw3tnBHi7E',
//      'o2hjwv2',
//      'Hô Chí Minh',
//    );
  }
}
