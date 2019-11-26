import 'dart:io';

import 'package:flutter/services.dart';
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
}
