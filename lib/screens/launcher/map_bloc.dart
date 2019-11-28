import 'package:travelspots/common/base_bloc.dart';

/// enum BaseBlocProperties
enum MapProperties {
  /// marker tap
  makerTapped,

  /// marker unTap
  makerUnTapped
}

/// Business Logic related to Map feature
class MapBloc extends BaseBloc<MapProperties> {
  @override
  String toString() {
    return 'MapBloc';
  }

  /// Notify that marker tapped
  void notifyMarkerTapped() {
    notifyListeners(MapProperties.makerTapped);
  }

  /// Notify that marker untapped
  void notifyMarkerUnTapped() {
    notifyListeners(MapProperties.makerUnTapped);
  }
}
