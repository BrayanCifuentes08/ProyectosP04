class PaDeleteUserElementoAsignadoM {
  final bool resultado;
  final String mensaje;

  PaDeleteUserElementoAsignadoM({
    required this.resultado,
    required this.mensaje,
  });

  factory PaDeleteUserElementoAsignadoM.fromJson(Map<String, dynamic> json) {
    return PaDeleteUserElementoAsignadoM(
      resultado: json['resultado'] as bool,
      mensaje: json['mensaje'] as String? ?? '',
    );
  }
}
