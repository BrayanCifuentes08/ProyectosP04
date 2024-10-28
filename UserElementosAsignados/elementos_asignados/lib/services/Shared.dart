import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Asegúrate de importar esto para IconData

class AccionService extends ChangeNotifier {
  Accion? _accion;

  Accion? get accion => _accion;

  // Método para actualizar el estado
  void setAccion(String texto) {
    _accion = Accion(texto);
    notifyListeners();
  }
}

class Accion {
  final String texto;

  Accion(this.texto);
}
