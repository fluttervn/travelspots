import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:travelspots/custom_packages/worker/worker.dart';
import 'package:travelspots/repos/implement/impl/app_database.dart';
import 'package:travelspots/repos/isolate_tasks/get_gsheet_task.dart';
import 'package:travelspots/repos/local/local_provider.dart';
import 'package:travelspots/repos/models/data_models/app_database_entity.dart';
import 'package:travelspots/repos/models/data_models/province_meta_model.dart';
import 'package:travelspots/repos/remote/remote_provider.dart';

import '../../app_repo.dart';
import 'task_utils.dart';

/// Implementation of AppRepo
/// [remoteProvider] responsible for handling data from network
/// [localProvider] responsible for handling data from local
/// [worker] object help calling method in other isolate (other process)
class AppRepoImpl extends AppRepo {
  /// Remote provider
  final RemoteProvider remoteProvider;

  /// Local provider
  final LocalProvider localProvider;

  final AppDatabase appDatabase;

  /// Worker
  final Worker worker;

  /// Constructor AppRepoImpl
  AppRepoImpl({
    this.remoteProvider,
    this.localProvider,
    this.appDatabase,
    this.worker,
  });

//  @override
//  Future<List<SpotDataModel>> getTravelSpotList() async {
//    final QuerySnapshot result = await Firestore.instance
//        .collection('spots')
//        .where('district_key', isEqualTo: 'quan_1')
//        .getDocuments();
//    final List<DocumentSnapshot> documents = result.documents;
//    Fimber.d('document: $documents');
//
//    return documents
//        .map((document) => SpotDataModel.fromDocument(document))
//        .toList();
//  }

//  @override
//  Future<bool> createTravelSpot({SpotDataModel data}) async {
//    try {
//      await Firestore.instance
//          .collection('relics')
//          .document()
//          .setData(data.toJsonData());
//      return true;
//    } catch (e) {
//      Fimber.d('createRelic error: $e');
//      return false;
//    }
//  }

  @override
  Future<void> testQueryByGeolocation({
    @required double latStart,
    @required double latEnd,
    @required double longStart,
    @required double longEnd,
  }) async {
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      // Test: all POIs in `quan_1` with lat & long in range
      Query query = Firestore.instance.collection('spots');
      // TODO(triet) Try to fix query in multiple fields
      // https://stackoverflow.com/questions/47633483/not-know-exception-with-firebase-filters/47634225
      /*.where('lat', isGreaterThan: latStart)
          .where('lat', isLessThan: latEnd);*/

      var snapshot = await query
          .where('long', isGreaterThan: longStart)
          .where('long', isLessThan: longEnd)
          .getDocuments();
      var documents = snapshot.documents;

      Fimber.d('testQueryByGeolocation: documents = ${documents.length}, '
          'time= ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.reset();
    } catch (e) {
      Fimber.d('testQueryByGeolocation: createRelic error: $e');
      return false;
    }
    return null;
  }

  @override
  Future<List<SpotEntity>> importGSheetData(
      String spreadSheetId, String workSheetId, String provinceName) async {
    var task = GetGSheetTask(
      remoteProvider: remoteProvider,
      spreadSheetId: spreadSheetId,
      workSheetId: workSheetId,
      provinceName: provinceName,
    );
    var results = await handleWorkerTask<List<SpotEntity>>(
      worker: worker,
      task: task,
    );
    return results;
  }

  @override
  Future<List<ProvinceMetaModel>> getProvinceMetaList() async {
    print('getProvinceMetaList');
    try {
      final QuerySnapshot result =
          await Firestore.instance.collection('provinces').getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      print('document: $documents');

      var listMeta = documents
          .map((document) => ProvinceMetaModel.fromDocument(document))
          .toList();
      print('list meta: $listMeta');
      return listMeta;
    } catch (e) {
      Fimber.d('createRelic error: $e');
      return null;
    }
  }

  @override
  Future<ProvinceMetaData> getOutOfDateProvinces() async {
    List<ProvinceMetaModel> serverList = await getProvinceMetaList();
    Map<String, int> localIdTime = await localProvider.getAll();

    // Compare local list vs. server list
    List<ProvinceMetaModel> outOfDateList = [];
    Map<String, int> localIdTimeAll = Map();

    print('serverList: $serverList');
    print('localIdTime: $localIdTime');

    serverList.forEach((provinceMetaModel) {
      String key = provinceMetaModel.uniqueKey;
      var localLastUpdate = localIdTime == null ? 0 : localIdTime[key] ?? 0;
      print('check out of date: key=$key: localLastUpdate: $localLastUpdate, '
          'serverLastUpdate=${provinceMetaModel.lastUpdate}');
      if (provinceMetaModel.lastUpdate > localLastUpdate) {
        outOfDateList.add(provinceMetaModel);
      }
      localIdTimeAll[key] = provinceMetaModel.lastUpdate;
    });
    if (outOfDateList.isNotEmpty) {
      localProvider.setAll(localIdTimeAll);
    }

    ProvinceMetaData provinceMetaData = ProvinceMetaData(
      serverList: serverList,
      localIdTimeAll: localIdTimeAll,
      outOfDateList: outOfDateList,
    );
    return provinceMetaData;
  }

  @override
  Future setProvinceMetaList(Map<String, int> localIdTimeAll) {
    localProvider.setAll(localIdTimeAll);
    return null;
  }

  @override
  Future setTravelSpotList(List<SpotEntity> items) async {
    await appDatabase.spotDao.insertDataFirstTime(items);
    return null;
  }

  @override
  Future updateTravelSpotList({
    List<SpotEntity> spotList,
    List<String> uniqueKeys,
  }) async {
    await appDatabase.spotDao.updateTravelSpotList(spotList, uniqueKeys);
    return null;
  }
}
