import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber.dart';
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
        .collection('provinces')
        .document('ho_chi_minh')
        .collection('quan_1')
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
  Future<void> testQueryByGeolocation() async {
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      // Test: all POIs in `quan_1` with lat & long in range
      var snapshot;
      var documents;

      /*snapshot = await Firestore.instance
          .collection('provinces')
          .document('ho_chi_minh')
          .collection('huyen_binh_chanh')
          .getDocuments();
      documents = snapshot.documents;

      Fimber.d('testQueryByGeolocation: 1. documents = ${documents.length}, '
          'time= ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.reset();

      snapshot = await Firestore.instance
          .collection('provinces')
          .document('ho_chi_minh')
          .collection('huyen_binh_chanh')
          .getDocuments();
      documents = snapshot.documents;
      Fimber.d('testQueryByGeolocation: 2. documents = ${documents.length}, '
          'time= ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.reset();

      snapshot = await Firestore.instance
          .collection('provinces')
          .document('ho_chi_minh')
          .collection('huyen_binh_chanh')
          .getDocuments(source: Source.cache);
      documents = snapshot.documents;

      Fimber.d('testQueryByGeolocation: 3. documents = ${documents.length}, '
          'time= ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.reset();*/

      // lat in range [x, y], long in range [a, b]
      snapshot = await Firestore.instance
          .collection('spots')
          .where('long', isGreaterThan: 106.7893492)
          .where('long', isLessThan: 106.7993492)
          .getDocuments();
      documents = snapshot.documents;

      Fimber.d('testQueryByGeolocation: 4. documents = ${documents.length}, '
          'time= ${stopwatch.elapsed.inMilliseconds}');
      stopwatch.reset();
    } catch (e) {
      Fimber.d('testQueryByGeolocation: createRelic error: $e');
      return false;
    }
    return null;
  }
}
