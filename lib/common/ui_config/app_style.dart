import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import 'ui_color_size.dart';

String _appFontFamily = 'Source Sans Pro';

/// Get any size
TextStyle sSizeAny({double fSize, Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSize,
      color: color ?? colorBlack,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get small size (14pt)
TextStyle sSizeSmall({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeSmall,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get normal size (16pt)
TextStyle sSizeNormal(
    {Color color, FontWeight fontWeight, TextDecoration decoration}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeNormal,
      color: color ?? colorPrimary1,
      decoration: decoration ?? TextDecoration.none,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get normal bold size (16pt)
TextStyle sSizeNormalWeightBold({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeNormal,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fWeightBold));
}

/// Get normal font weight
TextStyle sSizeNormalWeightSemi({Color color}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeNormal,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fWeightSemi));
}

/// Get medium font weight (18pt)
TextStyle sSizeMedium({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeMedium,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get small font weight semi
TextStyle sSizeSmallWeightSemi({Color color}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeSmall,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fWeightSemi));
}

/// Get medium font weight semi
TextStyle sSizeMediumWeightSemi({Color color}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeMedium,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fWeightSemi));
}

/// Get large medium font weight (22pt)
TextStyle sSizeXMedium({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeXMedium,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get medium font weight semi
TextStyle sSizeXMediumWeightSemi({Color color}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeXMedium,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fWeightSemi));
}

/// Get medium font weight normal
TextStyle sSizeMediumWeightNormal({Color color}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeMedium,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fWeightNormal));
}

/// Get large size (26pt)
TextStyle sSizeLarge({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeLarge,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get large bold size
TextStyle sSizeLargeWeightBold({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeLarge,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fWeightBold));
}

/// Get x large size (28pt)
TextStyle sSizeXLarge({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeXLarge,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get xx large size (36pt)
TextStyle sSizeXXLarge({Color color, FontWeight fontWeight}) {
  return TextStyle(
      fontFamily: _appFontFamily,
      fontSize: fSizeXXLarge,
      color: color ?? colorPrimary1,
      fontWeight: _getActualFontWeight(fontWeight));
}

/// Get font weight
FontWeight _getActualFontWeight(FontWeight fontWeight) {
  final fWeight = fontWeight ?? fWeightNormal;

  if (fWeight == fWeightLight ||
      fWeight == fWeightNormal ||
      fWeight == fWeightSemi ||
      fWeight == fWeightBold) {
    return fWeight;
  } else {
    Fimber.d('Font weight ($fWeight) is not existed, using normal font!!!');
    return FontWeight.normal;
  }
}
