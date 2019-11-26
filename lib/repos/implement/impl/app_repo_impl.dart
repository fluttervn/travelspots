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
  Future<List<RelicDataModel>> getRelicList() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('relics').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    Fimber.d('document: $documents');

    return documents
        .map((document) => RelicDataModel.fromDocument(document))
        .toList();
  }

  @override
  Future<bool> createRelic({RelicDataModel data}) async {
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
}
