import 'package:flutter/material.dart';

class FloatingActionButtonNotifier extends ChangeNotifier {
  int _buttonState = 0;

  int get buttonState => _buttonState;

  void setButtonState(int state) {
    _buttonState = state;
    notifyListeners();
  }
}
