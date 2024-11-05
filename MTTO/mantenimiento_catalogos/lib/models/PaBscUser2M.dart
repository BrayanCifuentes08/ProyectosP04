class PaBscUser2M {
  final bool continuar;
  final String mensaje;
  final String userName;

  PaBscUser2M({
    required this.continuar,
    required this.mensaje,
    required this.userName,
  });

  factory PaBscUser2M.fromJson(Map<String, dynamic> json) {
    return PaBscUser2M(
      continuar: json['continuar'],
      mensaje: json['mensaje'],
      userName: json['userName'],
    );
  }
}
