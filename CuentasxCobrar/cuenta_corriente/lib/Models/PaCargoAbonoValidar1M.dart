class PaCargoAbonoValidar1M {
  final String mensaje;
  final bool resultado;

  PaCargoAbonoValidar1M({
    required this.mensaje,
    required this.resultado,
  });

  factory PaCargoAbonoValidar1M.fromJson(Map<String, dynamic> json) {
    return PaCargoAbonoValidar1M(
      mensaje: json['mensaje'],
      resultado: json['resultado'],
    );
  }
}
