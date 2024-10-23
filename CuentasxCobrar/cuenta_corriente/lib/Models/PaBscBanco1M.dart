class PaBscBanco1M {
  final int banco;
  final String nombre;
  final int orden;

  PaBscBanco1M({
    required this.banco,
    required this.nombre,
    required this.orden,
  });

  factory PaBscBanco1M.fromJson(Map<String, dynamic> json) {
    return PaBscBanco1M(
      banco: json['banco'],
      nombre: json['nombre'],
      orden: json['orden'],
    );
  }
}
