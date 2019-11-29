import 'package:cloud_firestore/cloud_firestore.dart';

/// RelicData Model
class ProvinceMetaModel {
  /// worksheet id
  String worksheetId;

  /// spreadsheet id
  String spreadsheetId;

  /// Name
  String name;

  /// Popularity
  DateTime lastUpdate;

  ProvinceMetaModel(
      {this.worksheetId, this.spreadsheetId, this.name, this.lastUpdate});

  @override
  String toString() {
    return 'ProvinceMetaModel{worksheetId: $worksheetId, spreadsheetId: $spreadsheetId, name: $name, lastUpdate: $lastUpdate}';
  }

  /// Constructor RelicData Model
  factory ProvinceMetaModel.fromDocument(DocumentSnapshot document) {
    print('document data: ${document.data}');
    Timestamp timestamp = document['last_update'];
    return ProvinceMetaModel(
      worksheetId: document['spreadsheet_id'],
      name: document['name'],
      spreadsheetId: document['spreadsheet_id'],
      lastUpdate: timestamp.toDate(),
    );
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      worksheetId: lastUpdate,
    };
  }
}
