import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Asegúrate de importar esto para IconData

class AccionService extends ChangeNotifier {
  Accion? _accion; // Estado inicial vacío

  Accion? get accion => _accion; // Getter para obtener el estado actual

  // Método para actualizar el estado
  void setAccion(String texto, IconData icono) {
    _accion = Accion(texto, icono); // Actualiza el estado con texto e ícono
    notifyListeners(); // Notifica a los oyentes sobre el cambio
  }
}

class Accion {
  final String texto;
  final IconData icono;

  Accion(this.texto, this.icono);
}
