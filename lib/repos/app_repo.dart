import 'package:flutter/cupertino.dart';
import 'package:travelspots/repos/models/data_models/province_meta_model.dart';

import 'models/data_models/app_database_entity.dart';
import 'models/data_models/spot_data_model.dart';

/// Interface to call data related to common data of application.
/// This is only abstract class, you must implement method inside this class.
abstract class AppRepo {
  ///Method to get data from Google Sheet and import to local database
  Future<List<SpotEntity>> importGSheetData(
      String spreadSheetId, String workSheetId, String provinceName);

  /// Method to call getting Province meta
  Future<List<ProvinceMetaModel>> getProvinceMetaList();

  /// Method to get list of Province which need to update
  Future<ProvinceMetaData> getOutOfDateProvinces();

  /// Update province meta data
  Future setProvinceMetaList(Map<String, int> localIdTimeAll);

  /// Method to call getting Relics
  Future<List<SpotDataModel>> getTravelSpotList();

  /// Save list of Spots into database
  Future setTravelSpotList(List<SpotEntity> items);

  Future<bool> createTravelSpot({SpotDataModel data});

  Future<void> testQueryByGeolocation({
    @required double latStart,
    @required double latEnd,
    @required double longStart,
    @required double longEnd,
  });
}

class ProvinceMetaData {
  /// Full province metadata from server
  final List<ProvinceMetaModel> serverList;

  /// Mapper of Full province metadata from server to the cache province
  /// metadata
  final Map<String, int> localIdTimeAll;

  /// The list of out-of-date province metadata which needs to update
  final List<ProvinceMetaModel> outOfDateList;

  ProvinceMetaData({this.serverList, this.localIdTimeAll, this.outOfDateList});
}
