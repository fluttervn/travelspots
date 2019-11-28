import 'models/data_models/relic_data_model.dart';

/// Interface to call data related to common data of application.
/// This is only abstract class, you must implement method inside this class.
abstract class AppRepo {
  /// Method to call getting Relics
  Future<List<SpotDataModel>> getTravelSpotList();
  Future<bool> createTravelSpot({SpotDataModel data});
}
