class PaInsertUserElementoAsignadoM {
  final bool resultado;
  final String mensaje;

  PaInsertUserElementoAsignadoM({
    required this.resultado,
    required this.mensaje,
  });

  factory PaInsertUserElementoAsignadoM.fromJson(Map<String, dynamic> json) {
    return PaInsertUserElementoAsignadoM(
      resultado: json['resultado'],
      mensaje: json['mensaje'] ?? '',
    );
  }
}
