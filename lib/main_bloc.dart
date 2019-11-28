import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'common/base_bloc.dart';
import 'repos/app_repo.dart';
import 'repos/flt_exception.dart';
import 'repos/models/data_models/relic_data_model.dart';
import 'repos/models/ui_models/relic_ui_model.dart';

/// Business Logic related to Login feature
class MainBloc extends BaseBloc<BaseBlocProperties> {
  /// Provide account data from network or local
  final AppRepo appRepo;
  List<SpotUIModel> spots;

  /// Error message
  String errorMessage = '';

  /// Create instance of AccountBloc, it require repository to get data.
  MainBloc({
    @required this.appRepo,
  }) : assert(appRepo != null);

  @override
  String toString() {
    return 'MainBloc';
  }

  /// Method to call getting Relics
  Future<List<SpotUIModel>> getTravelSpots() async {
    try {
      notifyListeners(BaseBlocProperties.loading);
      List<SpotDataModel> relicsData = await appRepo.getTravelSpotList();
      spots = relicsData.map((item) => SpotUIModel.fromData(item)).toList();

      Fimber.d('relic data: $spots');

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
  Future<void> testQueryByGeolocation() async {
    await appRepo.testQueryByGeolocation();
  }
}
