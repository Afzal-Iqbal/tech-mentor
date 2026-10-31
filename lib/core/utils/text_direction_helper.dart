import 'package:flutter/material.dart';

/// Helper utility for handling RTL (Urdu) text directions and font families.
class TextDirectionHelper {
  TextDirectionHelper._();

  static bool isRtl(String languageCode) {
    return languageCode == 'ur';
  }

  static TextDirection getDirection(String languageCode) {
    return isRtl(languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }

  static TextAlign getAlignment(String languageCode) {
    return isRtl(languageCode) ? TextAlign.right : TextAlign.left;
  }
}
