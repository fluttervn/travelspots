import 'package:cloud_firestore/cloud_firestore.dart';

/// RelicData Model
class ProvinceMetaModel {
  /// worksheet id
  String worksheetId;

  /// spreadsheet id
  String spreadsheetId;

  /// Name
  String name;

  /// Last update
  int lastUpdate;

  ProvinceMetaModel(
      {this.worksheetId, this.spreadsheetId, this.name, this.lastUpdate});

  @override
  String toString() {
    return 'ProvinceMetaModel{worksheetId: $worksheetId, spreadsheetId: $spreadsheetId, name: $name, lastUpdate: $lastUpdate}';
  }

  /// Constructor RelicData Model
  factory ProvinceMetaModel.fromDocument(DocumentSnapshot document) {
    print('document data: ${document.data}');
    return ProvinceMetaModel(
      worksheetId: document['worksheet_id'],
      name: document['name'],
      spreadsheetId: document['spreadsheet_id'],
      lastUpdate: document['last_update'],
    );
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      worksheetId: lastUpdate,
    };
  }
}
