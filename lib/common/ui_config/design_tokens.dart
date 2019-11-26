import 'dart:async' show Future;
import 'dart:convert';
import 'dart:ui';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'ui_color_size.dart';

/// design token from xml when opening app
class DesignTokens {
  /// init data
  static Future<void> initData() async {
    final stopwatch = Stopwatch()..start();
    Fimber.d('~~~ START: DesignTokens.initData');

    Map<String, dynamic> jsonObj;
    String assetsPath = 'assets/design';
    String fileName = 'aliases';

    jsonObj = await loadAssetsToJson('$assetsPath/$fileName.json');

    String aliasVersion = jsonObj['version'];
    Map<String, dynamic> mapColorHex = jsonObj['aliases'];

    if (aliasVersion != null && aliasVersion.isNotEmpty) {
      // This is modified version of alias
      // Parse color first
      colorWhite = mapAliasColor('WHITE', mapColorHex);
      colorBlack = mapAliasColor('BLACK', mapColorHex);
      colorWhisper = mapAliasColor('WHISPER', mapColorHex);
      colorPrimary1 = mapAliasColor('PRIMARY_1', mapColorHex);
      colorLightPrimary1 = mapAliasColor('LIGHT_PRIMARY_1', mapColorHex);
      colorDarkPrimary1 = mapAliasColor('DARK_PRIMARY_1', mapColorHex);
      colorPrimary2 = mapAliasColor('PRIMARY_2', mapColorHex);
      colorLightPrimary2 = mapAliasColor('LIGHT_PRIMARY_2', mapColorHex);
      colorDarkPrimary2 = mapAliasColor('DARK_PRIMARY_2', mapColorHex);
      colorPrimary3 = mapAliasColor('PRIMARY_3', mapColorHex);
      colorLightPrimary3 = mapAliasColor('LIGHT_PRIMARY_3', mapColorHex);
      colorDarkPrimary3 = mapAliasColor('DARK_PRIMARY_3', mapColorHex);
      colorRed = mapAliasColor('RED', mapColorHex);
      colorLightRed = mapAliasColor('LIGHT_RED', mapColorHex);
      colorDarkRed = mapAliasColor('DARK_RED', mapColorHex);
      colorPaleRed = mapAliasColor('PALE_RED', mapColorHex);
      colorGreen = mapAliasColor('GREEN', mapColorHex);
      colorLightGreen = mapAliasColor('LIGHT_GREEN', mapColorHex);
      colorDarkGreen = mapAliasColor('DARK_GREEN', mapColorHex);
      colorYellow = mapAliasColor('YELLOW', mapColorHex);
      colorLightYellow = mapAliasColor('LIGHT_YELLOW', mapColorHex);
      colorDarkYellow = mapAliasColor('DARK_YELLOW', mapColorHex);
      colorOrange = mapAliasColor('ORANGE', mapColorHex);
      colorLightOrange = mapAliasColor('LIGHT_ORANGE', mapColorHex);
      colorDarkOrange = mapAliasColor('DARK_ORANGE', mapColorHex);
      colorPurple = mapAliasColor('PURPLE', mapColorHex);
      colorLightPurple = mapAliasColor('LIGHT_PURPLE', mapColorHex);
      colorDarkPurple = mapAliasColor('DARK_PURPLE', mapColorHex);
      colorMagenta = mapAliasColor('MAGENTA', mapColorHex);
      colorLightMagenta = mapAliasColor('LIGHT_MAGENTA', mapColorHex);
      colorDarkMagenta = mapAliasColor('DARK_MAGENTA', mapColorHex);
      colorBlue = mapAliasColor('BLUE', mapColorHex);
      colorLightBlue = mapAliasColor('LIGHT_BLUE', mapColorHex);
      colorDarkBlue = mapAliasColor('DARK_BLUE', mapColorHex);
      colorSky = mapAliasColor('SKY', mapColorHex);
      colorLightSky = mapAliasColor('LIGHT_SKY', mapColorHex);
      colorDarkSky = mapAliasColor('DARK_SKY', mapColorHex);
      colorCyan = mapAliasColor('CYAN', mapColorHex);
      colorLightCyan = mapAliasColor('LIGHT_CYAN', mapColorHex);
      colorDarkCyan = mapAliasColor('DARK_CYAN', mapColorHex);
      colorBlueGray = mapAliasColor('BLUE_GRAY', mapColorHex);
      colorLightBlueGray = mapAliasColor('LIGHT_BLUE_GRAY', mapColorHex);
      colorDarkBlueGray = mapAliasColor('DARK_BLUE_GRAY', mapColorHex);
      colorGray100 = mapAliasColor('GRAY_100', mapColorHex);
      colorGray200 = mapAliasColor('GRAY_200', mapColorHex);
      colorGray300 = mapAliasColor('GRAY_300', mapColorHex);
      colorGray400 = mapAliasColor('GRAY_400', mapColorHex);
      colorGray500 = mapAliasColor('GRAY_500', mapColorHex);
      colorGray600 = mapAliasColor('GRAY_600', mapColorHex);
      colorGray700 = mapAliasColor('GRAY_700', mapColorHex);
      colorGray800 = mapAliasColor('GRAY_800', mapColorHex);
      colorGray900 = mapAliasColor('GRAY_900', mapColorHex);
      colorTertiary1 = mapAliasColor('TERTIARY_1', mapColorHex);
      colorTertiary2 = mapAliasColor('TERTIARY_2', mapColorHex);
      colorTertiary3 = mapAliasColor('TERTIARY_3', mapColorHex);
      colorTertiary4 = mapAliasColor('TERTIARY_4', mapColorHex);
      colorTertiary5 = mapAliasColor('TERTIARY_5', mapColorHex);
      colorTertiary6 = mapAliasColor('TERTIARY_6', mapColorHex);
      colorTertiary7 = mapAliasColor('TERTIARY_7', mapColorHex);
    } else {
      fileName = 'color';

      jsonObj = await loadAssetsToJson('$assetsPath/$fileName.json');
      Map<String, dynamic> colorValueObj = jsonObj['props'];

      colorWhite = mapColor('WHITE', colorValueObj, mapColorHex);
      colorBlack = mapColor('BLACK', colorValueObj, mapColorHex);
      colorWhisper = mapColor('WHISPER', colorValueObj, mapColorHex);
      colorPrimary1 = mapColor('PRIMARY_1', colorValueObj, mapColorHex);
      colorLightPrimary1 =
          mapColor('LIGHT_PRIMARY_1', colorValueObj, mapColorHex);
      colorDarkPrimary1 =
          mapColor('DARK_PRIMARY_1', colorValueObj, mapColorHex);
      colorPrimary2 = mapColor('PRIMARY_2', colorValueObj, mapColorHex);
      colorLightPrimary2 =
          mapColor('LIGHT_PRIMARY_2', colorValueObj, mapColorHex);
      colorDarkPrimary2 =
          mapColor('DARK_PRIMARY_2', colorValueObj, mapColorHex);
      colorPrimary3 = mapColor('PRIMARY_3', colorValueObj, mapColorHex);
      colorLightPrimary3 =
          mapColor('LIGHT_PRIMARY_3', colorValueObj, mapColorHex);
      colorDarkPrimary3 =
          mapColor('DARK_PRIMARY_3', colorValueObj, mapColorHex);
      colorRed = mapColor('RED', colorValueObj, mapColorHex);
      colorLightRed = mapColor('LIGHT_RED', colorValueObj, mapColorHex);
      colorDarkRed = mapColor('DARK_RED', colorValueObj, mapColorHex);
      colorPaleRed = mapColor('PALE_RED', colorValueObj, mapColorHex);
      colorGreen = mapColor('GREEN', colorValueObj, mapColorHex);
      colorLightGreen = mapColor('LIGHT_GREEN', colorValueObj, mapColorHex);
      colorDarkGreen = mapColor('DARK_GREEN', colorValueObj, mapColorHex);
      colorYellow = mapColor('YELLOW', colorValueObj, mapColorHex);
      colorLightYellow = mapColor('LIGHT_YELLOW', colorValueObj, mapColorHex);
      colorDarkYellow = mapColor('DARK_YELLOW', colorValueObj, mapColorHex);
      colorOrange = mapColor('ORANGE', colorValueObj, mapColorHex);
      colorLightOrange = mapColor('LIGHT_ORANGE', colorValueObj, mapColorHex);
      colorDarkOrange = mapColor('DARK_ORANGE', colorValueObj, mapColorHex);
      colorPurple = mapColor('PURPLE', colorValueObj, mapColorHex);
      colorLightPurple = mapColor('LIGHT_PURPLE', colorValueObj, mapColorHex);
      colorDarkPurple = mapColor('DARK_PURPLE', colorValueObj, mapColorHex);
      colorMagenta = mapColor('MAGENTA', colorValueObj, mapColorHex);
      colorLightMagenta = mapColor('LIGHT_MAGENTA', colorValueObj, mapColorHex);
      colorDarkMagenta = mapColor('DARK_MAGENTA', colorValueObj, mapColorHex);
      colorBlue = mapColor('BLUE', colorValueObj, mapColorHex);
      colorLightBlue = mapColor('LIGHT_BLUE', colorValueObj, mapColorHex);
      colorDarkBlue = mapColor('DARK_BLUE', colorValueObj, mapColorHex);
      colorSky = mapColor('SKY', colorValueObj, mapColorHex);
      colorLightSky = mapColor('LIGHT_SKY', colorValueObj, mapColorHex);
      colorDarkSky = mapColor('DARK_SKY', colorValueObj, mapColorHex);
      colorCyan = mapColor('CYAN', colorValueObj, mapColorHex);
      colorLightCyan = mapColor('LIGHT_CYAN', colorValueObj, mapColorHex);
      colorDarkCyan = mapColor('DARK_CYAN', colorValueObj, mapColorHex);
      colorBlueGray = mapColor('BLUE_GRAY', colorValueObj, mapColorHex);
      colorLightBlueGray =
          mapColor('LIGHT_BLUE_GRAY', colorValueObj, mapColorHex);
      colorDarkBlueGray =
          mapColor('DARK_BLUE_GRAY', colorValueObj, mapColorHex);
      colorGray100 = mapColor('GRAY_100', colorValueObj, mapColorHex);
      colorGray200 = mapColor('GRAY_200', colorValueObj, mapColorHex);
      colorGray300 = mapColor('GRAY_300', colorValueObj, mapColorHex);
      colorGray400 = mapColor('GRAY_400', colorValueObj, mapColorHex);
      colorGray500 = mapColor('GRAY_500', colorValueObj, mapColorHex);
      colorGray600 = mapColor('GRAY_600', colorValueObj, mapColorHex);
      colorGray700 = mapColor('GRAY_700', colorValueObj, mapColorHex);
      colorGray800 = mapColor('GRAY_800', colorValueObj, mapColorHex);
      colorGray900 = mapColor('GRAY_900', colorValueObj, mapColorHex);
      colorTertiary1 = mapColor('TERTIARY_1', colorValueObj, mapColorHex);
      colorTertiary2 = mapColor('TERTIARY_2', colorValueObj, mapColorHex);
      colorTertiary3 = mapColor('TERTIARY_3', colorValueObj, mapColorHex);
      colorTertiary4 = mapColor('TERTIARY_4', colorValueObj, mapColorHex);
      colorTertiary5 = mapColor('TERTIARY_5', colorValueObj, mapColorHex);
      colorTertiary6 = mapColor('TERTIARY_6', colorValueObj, mapColorHex);
      colorTertiary7 = mapColor('TERTIARY_7', colorValueObj, mapColorHex);
    }

    // Now to font size
    fileName = 'font';
    jsonObj = await loadAssetsToJson('$assetsPath/$fileName.json');
    Map<String, dynamic> sizeValueObj = jsonObj['props'];

    fSizeSmall = mapFontSize('FONT_SIZE_SMALL', sizeValueObj);
    fSizeNormal = mapFontSize('FONT_SIZE_NORMAL', sizeValueObj);
    fSizeMedium = mapFontSize('FONT_SIZE_MEDIUM', sizeValueObj);
    fSizeXMedium = mapFontSize('FONT_SIZE_X_MEDIUM', sizeValueObj);
    fSizeLarge = mapFontSize('FONT_SIZE_LARGE', sizeValueObj);
    fSizeXLarge = mapFontSize('FONT_SIZE_X_LARGE', sizeValueObj);
    fSizeXXLarge = mapFontSize('FONT_SIZE_XX_LARGE', sizeValueObj);

    fileName = 'fontWeight';
    jsonObj = await loadAssetsToJson('$assetsPath/$fileName.json');
    Map<String, dynamic> weightWeightObj = jsonObj['props'];

    fWeightLight = mapFontWeight('FONT_WEIGHT_LIGHT', weightWeightObj);
    fWeightNormal = mapFontWeight('FONT_WEIGHT_NORMAL', weightWeightObj);
    fWeightSemi = mapFontWeight('FONT_WEIGHT_SEMI', weightWeightObj);
    fWeightBold = mapFontWeight('FONT_WEIGHT_BOLD', weightWeightObj);

    // Font weight can't use dynamic. To see detail font weight definition, please refer to: https://api.flutter.dev/flutter/dart-ui/FontWeight-class.html
//    fWeightLight = FontWeight.w300;
//    fWeightNormal = FontWeight.w400;
//    fWeightSemi = FontWeight.w600;
//    fWeightBold = FontWeight.w700;

    var elapsedTimeMs = stopwatch.elapsed.inMilliseconds;
    Fimber.d('~~~ END: DesignTokens:initData take $elapsedTimeMs ms');
    stopwatch.stop();
  }

  /// map color from xml
  static Color mapColor(
    String colorName,
    Map<String, dynamic> colorValueObj,
    Map<String, dynamic> mapColorHex,
  ) {
    Color color;
    var colorObj = colorValueObj['$colorName'];
    if (colorObj != null) {
      var tmpColorValue = colorObj['value'];
      var strColor = tmpColorValue.substring(2, tmpColorValue.length - 1);
      String textHex = mapColorHex['$strColor'];
      if (textHex != null && textHex.isNotEmpty) {
        color = convertTextHexToColor(textHex);
      }
    }
    if (color == null) {
      throw ArgumentError('Fail to mapColor() of `$colorName` from $colorObj');
    }
    Fimber.d('mapColor() of $colorName => $color');
    return color;
  }

  /// map font size
  static double mapFontSize(String sizeName, Map<String, dynamic> mapSizeObj) {
    double size;
    var sizeObj = mapSizeObj['$sizeName'];
    if (sizeObj != null) {
      String tmpSizeValue = sizeObj['value'];
      if (tmpSizeValue != null && tmpSizeValue.length >= 4) {
        String strSize = tmpSizeValue.substring(0, tmpSizeValue.length - 2);
        size = double.parse(strSize);
      }
    }
    if (size == null) {
      throw ArgumentError('Fail to mapFontSize() of `$sizeName` from $sizeObj');
    }
    // Fimber.d('mapFontSize() of $sizeName => $size');
    return size;
  }

  /// map font weight from xml
  static FontWeight mapFontWeight(
      String weightName, Map<String, dynamic> mapWeightObj) {
    int weight;
    var weightObj = mapWeightObj['$weightName'];
    if (weightObj != null) {
      String tmpSizeValue = weightObj['value'];
      if (tmpSizeValue != null && tmpSizeValue.length >= 3) {
        var sizeContent = tmpSizeValue.split(" ");
        if (sizeContent.isNotEmpty) {
          String strWeight = sizeContent[0];
          weight = double.parse(strWeight) ~/ 100; // parse to int
        }
      }
    }
    if (weight == null) {
      throw ArgumentError(
          'Fail to mapFontWeight() of `$weightName` from $weightObj');
    }
    FontWeight fontWeight = FontWeight.values[weight - 1]; // array is 0-based
    // Fimber.d('mapFontSize() of $weightName => $weight => $fontWeight');
    return fontWeight;
  }

  /// map color from alias xml
  static Color mapAliasColor(
      String colorName, Map<String, dynamic> mapColorHex) {
    var textColorHex = mapColorHex['$colorName'];
    Color color;
    if (textColorHex != null && textColorHex.isNotEmpty) {
      color = convertTextHexToColor(textColorHex);
    }
    if (color == null) {
      throw ArgumentError(
          'Fail to mapAliasColor() of `$colorName` from $textColorHex');
    }
    // Fimber.d('mapAliasColor() of $colorName => $color');
    return color;
  }

  /// load asset to json
  static Future<Map<String, dynamic>> loadAssetsToJson(
      String assetsFilePath) async {
    String content = await rootBundle.loadString(assetsFilePath);
    // Fimber.d('DesignTokens: $fileName.json: $strJsonContent');
    return jsonDecode(content);
  }

  /// Convert hex string, in format #RRGGBB, to Color
  static Color convertTextHexToColor(String textHex) {
    if (!textHex.startsWith('#')) {
      Fimber.d('color with hex {$textHex} not valid');
      textHex = '#$textHex';
    }
    return Color(int.parse(textHex.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
