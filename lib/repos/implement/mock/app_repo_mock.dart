import 'package:flutter/foundation.dart';
import 'package:travelspots/repos/models/data_models/relic_data_model.dart';

import '../../app_repo.dart';

/// Defining data for app repo
class AppRepoMock extends AppRepo {
  /// Simulate network request in 500 milliseconds
  Future<dynamic> wait({int milliseconds = 500}) async {
    return await Future.delayed(Duration(milliseconds: milliseconds));
  }

  @override
  Future<List<SpotDataModel>> getTravelSpotList() {
    // TODO: implement getRelicList
    return null;
  }

  @override
  Future<bool> createTravelSpot({SpotDataModel data}) {
    // TODO: implement createRelic
    return null;
  }

  @override
  Future<void> testQueryByGeolocation({
    @required double latStart,
    @required double latEnd,
    @required double longStart,
    @required double longEnd,
  }) async {
    // TODO: implement testQueryByGeolocation
    return null;
  }
}
