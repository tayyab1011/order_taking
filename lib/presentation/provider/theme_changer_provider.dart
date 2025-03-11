import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChangerProvider extends ChangeNotifier {
  ThemeMode _themeData = ThemeMode.system;
  ThemeMode get themeMode => _themeData;

  ThemeChangerProvider() {
    _loadTheme(); // Load theme from SharedPreferences on startup
  }

  void setTheme(ThemeMode theme) async {
    _themeData = theme;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', theme == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeStr = prefs.getString('themeMode');

    if (themeStr == 'dark') {
      _themeData = ThemeMode.dark;
    } else {
      _themeData = ThemeMode.light;
    }
    notifyListeners();
  }
}
