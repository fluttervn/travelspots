import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:travelspots/repos/models/data_models/relic_data_model.dart';

import 'app_utils.dart';

final String json_HaNoi =
    'https://spreadsheets.google.com/feeds/list/1PmcJMSFHiJo8J1-RALHcV-7pU41xAhabxvw3tnBHi7E/oxci3z6/public/values?alt=json';
final String json_HoChiMinh =
    'https://spreadsheets.google.com/feeds/list/1PmcJMSFHiJo8J1-RALHcV-7pU41xAhabxvw3tnBHi7E/o2hjwv2/public/values?alt=json';

final String jsonLink = json_HaNoi;

String provinceKey;

class CSVUtils {
  static readLocalTSV() async {
    var file = await AppUtils.getFileFromAssets('hcm_relics.tsv');

    Stream<List<int>> inputStream = file.openRead();

    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {
      // Process results.

      List<String> row = line.split(' '); // split by comma

      print('row: $row');

      String id = row[0];
      String symbol = row[1];
      String open = row[2];
//      String low = row[3];
//      String high = row[4];
//      String close = row[5];
//      String exchange = row[6];
//      String volume = row[7];
//      String date = row[8];
//      String timestamp = row[9];

//      print('$id, $symbol, $open');
    }, onDone: () {
      print('File is now closed.');
    }, onError: (e) {
      print(e.toString());
    });
  }

  static importJsonDataToFirestore() async {
    //Get json from google
    var listData = await _getJsonData();
    var batch;

    //Delete all data before importing
    batch = Firestore.instance.batch();
    var snapshot = await Firestore.instance
        .collection('spots')
        .where('province_key', isEqualTo: provinceKey)
        .getDocuments();
    for (DocumentSnapshot document in snapshot.documents) {
      batch.delete(document.reference);
    }
    await batch.commit();

    //Convert json to Firebase json and import to Firestore
    batch = Firestore.instance.batch();
    for (var itemJson in listData) {
      var item = SpotDataModel.fromGoogleJson(itemJson, provinceKey);

      batch.setData(
          Firestore.instance.collection('spots').document(), item.toJsonData());
    }

    batch.commit();
  }

  static Future<List> _getJsonData() async {
    final Dio dio = Dio();
    var completer = Completer<List>();

    try {
      var response = await dio.get(jsonLink);
      var list = response.data['feed']['entry'];
      provinceKey = response.data['feed']['title']['\u0024t'];

      print('provinceKey: $provinceKey');

      print('result=$list');

      completer.complete(list);
    } catch (e) {
      print('error: $e');
      completer.completeError(e);
    }

    return completer.future;
  }
}
