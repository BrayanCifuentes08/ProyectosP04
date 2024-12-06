import 'package:flutter/material.dart';

class UrlProvider extends ChangeNotifier {
  String _baseUrl = '';

  String get baseUrl => _baseUrl;

  void setBaseUrl(String url) {
    _baseUrl = url;
    notifyListeners();
  }
}
