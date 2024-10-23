class PaBscEstacionTrabajo2M {
  final int estacionTrabajo;
  final String nombre;
  final String descripcion;

  PaBscEstacionTrabajo2M({
    required this.estacionTrabajo,
    required this.nombre,
    required this.descripcion,
  });

  factory PaBscEstacionTrabajo2M.fromJson(Map<String, dynamic> json) {
    return PaBscEstacionTrabajo2M(
      estacionTrabajo: json['estacion_Trabajo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}
