import 'package:mantenimiento_catalogos/models/ModeloInputs.dart';

class PaCrudElementoAsignadoM implements ModelWithFields {
  int? elementoAsignado;
  String? descripcion;
  int? elementoId;
  int? empresa;
  String? elementoAsignadoPadre;
  int? estado;
  DateTime? fechaHora;
  String? userName;
  String? mensaje;
  bool resultado;

  PaCrudElementoAsignadoM({
    required this.elementoAsignado,
    required this.descripcion,
    required this.elementoId,
    required this.empresa,
    required this.elementoAsignadoPadre,
    required this.estado,
    required this.fechaHora,
    required this.userName,
    required this.mensaje,
    required this.resultado,
  });

  @override
  Map<String, dynamic> getFields() {
    return {
      "Elemento Asignado": elementoAsignado,
      'Descripción': descripcion,
      "Elemento Id": elementoId,
      "Empresa": empresa,
      "Elemento Asignado Padre": elementoAsignadoPadre,
      "Fecha y Hora": fechaHora,
      "UserName": userName,
      'Estado': estado,
    };
  }

  @override
  Map<String, bool> getCamposBloqueadosUpdate() {
    return {
      "Elemento Asignado": true, // Bloqueado
      'Descripción': false, // Editables
      "Elemento Id": true, // Bloqueado
      "Empresa": true, // Bloqueado
      "Elemento Asignado Padre": true, // Bloqueado
      "Estado": false, // Editable
      "Fecha y Hora": true, // Bloqueado
      "UserName": true, // Bloqueado
    };
  }

  @override
  Map<String, bool> getCamposBloqueadosInsert() {
    return {
      "Elemento Asignado": true, // Bloqueado
      "Descripción": false, // Editables
      "Elemento Id": true, // Bloqueado
      "Empresa": true, // Bloqueado
      "Elemento Asignado Padre": false, // Editables
      "Estado": true, // Bloqueado
      "Fecha y Hora": true, // Bloqueado
      "UserName": true, // Bloqueado
    };
  }

  @override
  Map<String, String> getTiposDeCampo() {
    return {
      "Elemento Asignado": "int", // tipo int
      'Descripción': "text", //  Campo de texto
      "Elemento Id": "text", // Campo de texto
      "Empresa": "int", // tipo int
      "Elemento Asignado Padre": "dropdown", // tipo dropdown
      "Estado": "switch", // tipo switch
      "Fecha y Hora": "date", // Campo de fecha
      "UserName": "text", // Campo de texto
    };
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'elementoAsignado': elementoAsignado,
      'descripcion': descripcion,
      'elementoId': elementoId,
      'empresa': empresa,
      'elementoAsignadoPadre': elementoAsignadoPadre,
      'estado': estado,
      'fechaHora': fechaHora,
      'userName': userName,
      'mensaje': mensaje,
      'resultado': resultado,
    };
  }

  // Método para crear una instancia desde JSON
  factory PaCrudElementoAsignadoM.fromJson(Map<String, dynamic> json) {
    print("Convirtiendo desde JSON: $json"); // Para depuración
    return PaCrudElementoAsignadoM(
      elementoAsignado: json['elementoAsignado'] as int?,
      descripcion: json['descripcion'] as String? ?? '',
      elementoId: json['elementoId'] as int?,
      empresa: json['empresa'] as int?,
      elementoAsignadoPadre: json['elementoAsignadoPadre'] as String? ?? '',
      estado: json['estado'] as int?,
      fechaHora: json['fecha_Hora'] != null
          ? DateTime.tryParse(json['fecha_Hora'])
          : null,
      userName: json['userName'] as String? ?? '',
      mensaje: json['mensaje'] as String? ?? '',
      resultado: json['resultado'] as bool,
    );
  }
}
