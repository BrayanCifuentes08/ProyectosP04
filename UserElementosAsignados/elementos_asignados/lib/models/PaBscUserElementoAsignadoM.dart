class PaBscUserElementoAsignadoM {
  final String userName;
  final int elementoAsignado;
  final String descripcion;
  final DateTime fechaHora;

  PaBscUserElementoAsignadoM({
    required this.userName,
    required this.elementoAsignado,
    required this.descripcion,
    required this.fechaHora,
  });

  factory PaBscUserElementoAsignadoM.fromJson(Map<String, dynamic> json) {
    return PaBscUserElementoAsignadoM(
      userName: json['userName'],
      elementoAsignado: json['elemento_Asignado'],
      descripcion: json['descripcion'],
      fechaHora: DateTime.tryParse(json['fecha_Hora']) ?? DateTime.now(),
    );
  }
}
