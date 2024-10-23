import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogoProvider extends ChangeNotifier {
  String? _selectedValue;

  OpcionNotifier() {
    _loadFromPrefs();
  }

  String? get selectedValue => _selectedValue;

  void setSelectedValue(String? value) {
    _selectedValue = value;
    _saveToPrefs();
    notifyListeners();
  }

  _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedValue = prefs.getString('opcionMantenimiento') ?? null;
    notifyListeners();
  }

  _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('opcionMantenimiento', _selectedValue ?? '');
  }
}
