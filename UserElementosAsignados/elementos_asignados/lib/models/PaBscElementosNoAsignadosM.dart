class PaBscElementosNoAsignadosM {
  final int elementoAsignado;
  final String descripcion;

  PaBscElementosNoAsignadosM({
    required this.elementoAsignado,
    required this.descripcion,
  });

  factory PaBscElementosNoAsignadosM.fromJson(Map<String, dynamic> json) {
    return PaBscElementosNoAsignadosM(
      elementoAsignado: json['elemento_Asignado'],
      descripcion: json['descripcion'],
    );
  }
}
