class PaTblDocumentoEstructuraM {
  final int consecutivoInterno;
  final String estructura;
  final String userName;
  final DateTime fechaHora;
  final int tipoEstructura;
  final int estado;

  PaTblDocumentoEstructuraM({
    required this.consecutivoInterno,
    required this.estructura,
    required this.userName,
    required this.fechaHora,
    required this.tipoEstructura,
    required this.estado,
  });

  factory PaTblDocumentoEstructuraM.fromJson(Map<String, dynamic> json) {
    return PaTblDocumentoEstructuraM(
      consecutivoInterno: json['consecutivo_Interno'] as int,
      estructura: json['estructura'] as String,
      userName: json['userName'] as String,
      fechaHora: DateTime.parse(json['fecha_Hora']),
      tipoEstructura: json['tipo_Estructura'] as int,
      estado: json['estado'] as int,
    );
  }
}
