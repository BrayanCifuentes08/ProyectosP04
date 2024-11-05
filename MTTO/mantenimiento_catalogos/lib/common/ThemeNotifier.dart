import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _temaClaro = true;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  bool get temaClaro => _temaClaro;

  toggleTheme() {
    _temaClaro = !_temaClaro;
    _saveToPrefs();
    notifyListeners();
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _temaClaro = prefs.getBool('temaClaro') ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('temaClaro', _temaClaro);
  }
}
