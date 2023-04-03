import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silvertime/locator.dart';

enum Mode {
  light,
  dark,
  system
}

class UI extends ChangeNotifier {
  SharedPreferences prefs = locator<SharedPreferences>();
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get themeMode => _mode;
  Mode modeVal = Mode.light;

  String _locale = "en";
  String get locale => _locale;

  void fetchMode() {
    Mode mode = Mode.values[prefs.getInt("mode")??0];
    if(mode == Mode.light) {
      _mode = ThemeMode.light;
    }else if(mode == Mode.dark) {
      _mode = ThemeMode.dark;
    }else {
      _mode = ThemeMode.system;
    }
    modeVal = mode;
  }

  void fetchLocale() {
    _locale = prefs.getString("locale")??"en";
  }

  void fetchSettings() {
    fetchMode();
    fetchLocale();
  }

  

  set mode(Mode mode) {
    if(mode == Mode.light) {
      _mode = ThemeMode.light;
    }else if(mode == Mode.dark) {
      _mode = ThemeMode.dark;
    }else {
      _mode = ThemeMode.system;
    }
    modeVal = mode;
    prefs.setInt("mode", mode.index);
    notifyListeners();
  }

  set locale(String locale) {
    _locale = locale;
    prefs.setString("locale", locale);
    notifyListeners();
  }

}