import 'package:cloud_firestore/cloud_firestore.dart';

/// RelicData Model
class ProvinceMetaModel {
  /// worksheet id
  String worksheetId;

  /// spreadsheet id
  String spreadsheetId;

  /// Name
  String provinceName;

  /// Last update
  int lastUpdate;

  // Unique is the combination of spreadsheetId + worksheetId
  String uniqueKey;

  ProvinceMetaModel(
      {this.worksheetId,
      this.spreadsheetId,
      this.provinceName,
      this.lastUpdate}) {
    uniqueKey = '$spreadsheetId-$worksheetId';
  }

  @override
  String toString() {
    return 'ProvinceMetaModel{worksheetId: $worksheetId, spreadsheetId: $spreadsheetId, provinceName: $provinceName, lastUpdate: $lastUpdate}';
  }

  /// Constructor RelicData Model
  factory ProvinceMetaModel.fromDocument(DocumentSnapshot document) {
    print('document data: ${document.data}');
    return ProvinceMetaModel(
      worksheetId: document['worksheet_id'],
      provinceName: document['province_name'],
      spreadsheetId: document['spreadsheet_id'],
      lastUpdate: document['last_update'],
    );
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      uniqueKey: lastUpdate,
    };
  }
}
