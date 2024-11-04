import 'package:flutter/material.dart';

class IdiomaNotifier extends ChangeNotifier {
  Locale _idiomaSeleccionado = Locale('es', 'ES');

  Locale get idiomaSeleccionado => _idiomaSeleccionado;

  void cambiarIdioma(Locale nuevoIdioma) {
    _idiomaSeleccionado = nuevoIdioma;
    notifyListeners();
  }
}
