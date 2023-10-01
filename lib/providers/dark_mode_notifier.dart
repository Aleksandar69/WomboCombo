import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeNotifier extends StateNotifier<bool> {
  late SharedPreferences prefs;
  var _darkMode;
  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool("darkMode");
    state = darkMode ?? false;
  }

  get darkMode => _darkMode;

  DarkModeNotifier() : super(false) {
    _init();
  }

  void toggle() async {
    state = !state;
    prefs.setBool("darkMode", state);
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(),
);
