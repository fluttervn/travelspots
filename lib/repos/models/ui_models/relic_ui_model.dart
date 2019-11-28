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

  /// Constructor UserRoleDataModel
  SpotUIModel({
    this.id,
    this.name,
    this.description,
    this.address,
  });

  factory SpotUIModel.fromData(SpotDataModel model) {
    return SpotUIModel(
      id: model.id,
      name: model.name,
      description: model.description ?? '',
      address: model.address,
    );
  }
}
