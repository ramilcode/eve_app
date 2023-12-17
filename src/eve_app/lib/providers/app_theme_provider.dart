import 'package:eve_app/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';

class AppThemeProvider extends ChangeNotifier {
  final _isDarkThemeKeyInSharedPrefs = "isDarkTheme";
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  AppThemeProvider() {
    load();
  }

  ///will toggle if value is null
  void setIsDarkTheme({bool? value}) {
    bool newIsDarkThemeValue = value ?? !isDarkTheme;
    SharedPrefsService().setSharedPrefBool(_isDarkThemeKeyInSharedPrefs, newIsDarkThemeValue);
    _isDarkTheme = newIsDarkThemeValue;
    notifyListeners();
  }

  void load() {
    _isDarkTheme = SharedPrefsService().getSharedPrefBool(_isDarkThemeKeyInSharedPrefs) ?? false;
    notifyListeners();
  }
}
