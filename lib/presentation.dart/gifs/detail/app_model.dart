import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    if (_themeMode != value) {
      _themeMode = value;
      notifyListeners();
    }
  }
}