import 'package:flutter/material.dart.';
import 'package:wombocombo/utils/theme_pref.dart';
import 'package:riverpod/riverpod.dart';

class ThemeNotifier with ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void init() async {
    _isDarkTheme = await themePreference
        .getTheme(); // get ThemeMode from shared preferences
    notifyListeners();
  }

  set setTheme(bool value) {
    _isDarkTheme = value;
    themePreference.setTheme(_isDarkTheme);
    notifyListeners();
  }
}
