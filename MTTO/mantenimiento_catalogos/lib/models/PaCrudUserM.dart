import 'dart:typed_data';

import 'package:mantenimiento_catalogos/models/ModeloInputs.dart';

class PaCrudUserM implements ModelWithFields {
  String? userName;
  String? name;
  String? celular;
  String? eMail;
  Uint8List? passKey;
  bool disable;
  int? empresa;
  int? estacionTrabajo;
  int? application;
  DateTime? fechaHora;
  String? mensaje;
  bool resultado;

  PaCrudUserM({
    required this.userName,
    required this.name,
    required this.celular,
    required this.eMail,
    required this.passKey,
    required this.disable,
    required this.empresa,
    required this.estacionTrabajo,
    required this.application,
    required this.fechaHora,
    required this.mensaje,
    required this.resultado,
  });

  @override
  Map<String, dynamic> getFields() {
    return {
      "UserName": userName,
      'Name': name,
      "Celular": celular,
      "EMail": eMail,
      "Fecha y Hora": fechaHora,
    };
  }

  @override
  Map<String, bool> getCamposBloqueadosUpdate() {
    return {
      "UserName": true, // Bloqueado
      'Name': false, // Editables
      "Celular": false, // Editables
      "EMail": false, // Editables
      "Fecha y Hora": true, // Bloqueado
    };
  }

  @override
  Map<String, bool> getCamposBloqueadosInsert() {
    return {
      "UserName": true, // Bloqueado
      'Name': false, // Editables
      "Celular": false, // Editables
      "EMail": false, // Editables
      "Fecha y Hora": true, // Bloqueado
    };
  }

  @override
  Map<String, String> getTiposDeCampo() {
    return {
      "UserName": "text", // Bloqueado
      'Name': "text", // Editables
      "Celular": "text", // Editables
      "EMail": "text", // Editables
      "Fecha y Hora": "date", // Bloqueado
    };
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'name': name,
      'celular': celular,
      'eMail': eMail,
      'passKey': passKey,
      'disable': disable,
      'empresa': empresa,
      'estacionTrabajo': estacionTrabajo,
      'application': application,
      'fechaHora': fechaHora,
      'mensaje': mensaje,
      'resultado': resultado,
    };
  }

  // Método para crear una instancia desde JSON
  factory PaCrudUserM.fromJson(Map<String, dynamic> json) {
    print("Convirtiendo desde JSON: $json"); // Para depuración
    return PaCrudUserM(
      userName: json['userName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      celular: json['celular'] as String? ?? '',
      eMail: json['eMail'] as String? ?? '',
      passKey: json['pass_Key'] as Uint8List,
      disable: json['disable'] as bool,
      empresa: json['empresa'] as int?,
      estacionTrabajo: json['estacionTrabajo'] as int?,
      application: json['application'] as int?,
      fechaHora: json['fecha_Hora'] != null
          ? DateTime.tryParse(json['fecha_Hora'])
          : null,
      mensaje: json['mensaje'] as String? ?? '',
      resultado: json['resultado'] as bool,
    );
  }
}
