import 'package:flutter/material.dart.';
import 'package:wombocombo/utils/theme_pref.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    themePreference.setTheme(_darkTheme);
    notifyListeners();
  }
}
