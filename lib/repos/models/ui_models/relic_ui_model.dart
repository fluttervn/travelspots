import 'package:travelspots/repos/models/data_models/relic_data_model.dart';

/// RelicsUI Model
class SpotUIModel {
  /// id
  String id;

  /// Name
  String name;

  /// description
  dynamic description;

  /// address
  String address;

  /// Lat
  double lat;

  /// Long
  double long;

  /// District
  String district;

  /// Constructor UserRoleDataModel
  SpotUIModel({
    this.id,
    this.name,
    this.description,
    this.address,
    this.lat,
    this.long,
    this.district,
  });

  factory SpotUIModel.fromData(SpotDataModel model) {
    return SpotUIModel(
      id: model.id,
      name: model.name,
      description: model.description ?? '',
      address: model.address,
      lat: model.lat,
      long: model.long,
      district: model.district,
    );
  }
}
