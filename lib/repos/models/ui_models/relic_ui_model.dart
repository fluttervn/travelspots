import 'package:travelspots/repos/models/data_models/relic_data_model.dart';

/// RelicsUI Model
class RelicUIModel {
  /// id
  String id;

  /// Name
  String name;

  /// description
  dynamic description;

  /// address
  String address;

  /// Constructor UserRoleDataModel
  RelicUIModel({
    this.id,
    this.name,
    this.description,
    this.address,
  });

  factory RelicUIModel.fromData(RelicDataModel model) {
    return RelicUIModel(
      id: model.id,
      name: model.ten,
      description: model.moTa,
      address: model.diaChi,
    );
  }
}
