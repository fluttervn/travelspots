import 'package:travelspots/repos/models/data_models/relic_data_model.dart';

import '../../app_repo.dart';

/// Defining data for app repo
class AppRepoMock extends AppRepo {
  /// Simulate network request in 500 milliseconds
  Future<dynamic> wait({int milliseconds = 500}) async {
    return await Future.delayed(Duration(milliseconds: milliseconds));
  }

  @override
  Future<List<RelicDataModel>> getRelicList() {
    // TODO: implement getRelicList
    return null;
  }

  @override
  Future<bool> createRelic({RelicDataModel data}) {
    // TODO: implement createRelic
    return null;
  }
}
