import 'package:mantenimiento_catalogos/models/ModeloInputs.dart';

class PaBscCanalDistribucionM implements ModelWithFields {
  int? tipoCanalDistribucion;
  int? bodega;
  String? descripcion;
  int? estado;
  DateTime? fechaHora;
  String? userName;
  String? mensaje;
  bool resultado;

  PaBscCanalDistribucionM({
    required this.tipoCanalDistribucion,
    required this.bodega,
    required this.descripcion,
    required this.estado,
    required this.fechaHora,
    required this.userName,
    required this.mensaje,
    required this.resultado,
  });

  @override
  Map<String, dynamic> getFields() {
    return {
      'Tipo Canal Distribución': tipoCanalDistribucion,
      'Bodega': bodega,
      'Descripción': descripcion,
      "Fecha y Hora": fechaHora,
      "UserName": userName,
      "Estado": estado,
    };
  }

  @override
  Map<String, bool> getCamposBloqueadosUpdate() {
    return {
      "Tipo Canal Distribución": true, // Bloqueado
      'Bodega': true, //Bloqueado
      "Descripción": false, // Editable
      "Estado": false, // Editable
      "Fecha y Hora": true, // Bloqueado
      "UserName": true, // Bloqueado
    };
  }

  @override
  Map<String, bool> getCamposBloqueadosInsert() {
    return {
      "Tipo Canal Distribución": false, // Editable
      'Bodega': true, //Bloqueado
      "Descripción": false, // Editable
      "Estado": true, // Bloqueado
      "Fecha y Hora": true, // Bloqueado
      "UserName": true, // Bloqueado
    };
  }

  @override
  Map<String, String> getTiposDeCampo() {
    return {
      "Tipo Canal Distribución": "dropdown", // Definido como dropdown
      "Bodega": "int",
      "Descripción": "text", // Campo de texto
      "Estado": "switch", // Puede ser un dropdown también
      "Fecha y Hora": "date", // Campo de texto
      "UserName": "text", // Campo de texto
    };
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'tipoCanalDistribucion': tipoCanalDistribucion,
      'descripcion': descripcion,
      'bodega': bodega,
      'estado': estado,
      'fechaHora': fechaHora,
      'userName': userName,
      'mensaje': mensaje,
      'resultado': resultado,
    };
  }

  // Método para crear una instancia desde JSON
  factory PaBscCanalDistribucionM.fromJson(Map<String, dynamic> json) {
    print("Convirtiendo desde JSON: $json"); // Para depuración
    return PaBscCanalDistribucionM(
      tipoCanalDistribucion: json['tipoCanalDistribucion'] as int?,
      bodega: json['bodega'] as int?,
      descripcion: json['descripcion'] as String? ?? '',
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
