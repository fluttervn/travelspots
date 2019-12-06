import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static Future<Directory> getDownloadDirectory(String path) async {
    final dir = await getApplicationDocumentsDirectory();

    var downloadPath = '${dir.path}/$path';

    final myDir = Directory(downloadPath);
    if (myDir.existsSync()) {
      return myDir;
    } else {
      await myDir.create(recursive: true);
    }

    return myDir;
  }

  static Future<File> getFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static List<double> calculateMapRegion(LatLngBounds visibleRegion) {
    double latStart = visibleRegion.southwest.latitude;
    double latEnd = visibleRegion.northeast.latitude;
    double widthExtra = (latEnd - latStart) * 0.25; // more 25% in each side

    double longStart = visibleRegion.southwest.longitude;
    double longEnd = visibleRegion.northeast.longitude;
    double heightExtra = (longEnd - longStart) * 0.25; // more 25% in each side

    return [
      latStart - widthExtra,
      latEnd + widthExtra,
      longStart - heightExtra,
      longEnd + heightExtra,
    ];
  }

  static parseIntOrException(String value) {
    return int.parse(value);
  }

  static parseInt(String value, int defaultValue) {
    if (value == null || value.isEmpty) {
      return defaultValue;
    }
    try {
      return int.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }

  static parseDouble(String value, double defaultValue) {
    if (value == null || value.isEmpty) {
      return defaultValue;
    }
    try {
      return double.parse(value);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Method help convert pattern to real url
  /// For example, pattern '/category/{qa_id}'
  /// values ['123']
  /// Real url will be '/category/123'
  static String mapURLPatternValue(String urlStr, {List values}) {
    var newUrl = urlStr;
    Fimber.d('before map: $newUrl');
    if (values != null) {
      for (int i = 0; i < values.length; i++) {
        var firstLeftBrace = newUrl.indexOf('{');
        var firstRightBrace = newUrl.indexOf('}');
        newUrl = newUrl.replaceRange(
            firstLeftBrace, firstRightBrace + 1, values[i].toString());
      }
    }
    Fimber.d('after map: $newUrl');
    return newUrl;
  }

  /// Convert the zoom level of MapView into the popularity of POI.
  ///
  /// - Zoom Level of map: from 0 to 23. 0 is largest map. 23 is most detailed.
  /// https://stackoverflow.com/a/32407072/190309
  /// - Popularity: 1 is for largest map, 2 for medium, and 3 for the most
  /// detailed map.
  static int convertMapZoomLevelToPopularity(double zoomLevel) {
//    print('convertMapZoomLevelToPopularity: $zoomLevel => ');
    if (zoomLevel == null) return 4;
    if (zoomLevel <= 9.5) return 1;
    if (zoomLevel <= 11.5) return 2;
    if (zoomLevel <= 13) return 3;
    return 4;
  }
}
