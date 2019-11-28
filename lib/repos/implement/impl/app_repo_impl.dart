import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:travelspots/repos/models/data_models/relic_data_model.dart';

import '../../app_repo.dart';

/// Implementation of AppRepo
/// [worker] object help calling method in other isolate (other process)
class AppRepoImpl extends AppRepo {
  /// Constructor AppRepoImpl
  AppRepoImpl();

  @override
  Future<List<SpotDataModel>> getTravelSpotList() async {
    final QuerySnapshot result = await Firestore.instance
        .collectionGroup('ho_chi_minh')
        .where('districtkey', arrayContains: 'huyen_binh_chanh')
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    Fimber.d('document: $documents');

    return documents
        .map((document) => SpotDataModel.fromDocument(document))
        .toList();
  }

  @override
  Future<bool> createTravelSpot({SpotDataModel data}) async {
    try {
      await Firestore.instance
          .collection('relics')
          .document()
          .setData(data.toJsonData());
      return true;
    } catch (e) {
      Fimber.d('createRelic error: $e');
      return false;
    }
  }

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
}
