class PaDocumentoValidar1M {
  final String mensaje;
  final bool resultado;

  PaDocumentoValidar1M({
    required this.mensaje,
    required this.resultado,
  });

  factory PaDocumentoValidar1M.fromJson(Map<String, dynamic> json) {
    return PaDocumentoValidar1M(
      mensaje: json['mensaje'],
      resultado: json['resultado'],
    );
  }
}
