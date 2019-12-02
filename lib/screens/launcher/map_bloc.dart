import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:travelspots/common/base_bloc.dart';

/// enum BaseBlocProperties
enum MapProperties {
  /// current location found
  locationFound,

  /// marker added
  markerAdded,

  /// marker tap
  markerTapped,

  /// marker unTap
  markerUnTapped
}

/// Business Logic related to Map feature
class MapBloc extends BaseBloc<MapProperties> {
  @override
  String toString() {
    return 'MapBloc';
  }

  /// Notify that location found
  void notifyLocationFound() {
    notifyListeners(MapProperties.locationFound);
  }

  /// Notify that marker added
  void notifyMarkerAdded() {
    notifyListeners(MapProperties.markerAdded);
  }

  /// Notify that marker tapped
  void notifyMarkerTapped() {
    Fimber.d('MapBloc:notifyMarkerTapped');
    notifyListeners(MapProperties.markerTapped);
  }

  /// Notify that marker untapped
  void notifyMarkerUnTapped() {
    notifyListeners(MapProperties.markerUnTapped);
  }

  /// Reset map properties
  void resetMapPropeties() {
    notifyListeners(null);
  }
}
