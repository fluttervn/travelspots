import 'package:flutter/cupertino.dart';
import 'package:travelspots/repos/models/data_models/province_meta_model.dart';

import 'models/data_models/app_database_entity.dart';
import 'models/data_models/relic_data_model.dart';

/// Interface to call data related to common data of application.
/// This is only abstract class, you must implement method inside this class.
abstract class AppRepo {
  ///Method to get data from Google Sheet and import to local database
  Future<List<SpotEntity>> importGSheetData(
      String spreadSheetId, String workSheetId, String provinceName);

  /// Method to call getting Province meta
  Future<List<ProvinceMetaModel>> getProvinceMetaList();

  /// Method to call getting Relics
  Future<List<SpotDataModel>> getTravelSpotList();

  Future<bool> createTravelSpot({SpotDataModel data});

  Future<void> testQueryByGeolocation({
    @required double latStart,
    @required double latEnd,
    @required double longStart,
    @required double longEnd,
  });
}
