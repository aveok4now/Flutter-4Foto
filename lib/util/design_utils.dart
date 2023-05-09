import 'package:flutter/material.dart';

class DesignUtils {
  bool isCupertino(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }

  bool isLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }
}