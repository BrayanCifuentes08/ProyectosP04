class PaBscEmpresa1M {
  final int empresa;
  final String empresaNombre;
  final String razonSocial;
  final String empresaNIT;
  final String empresaDireccion;
  final int numeroPatronal;
  final bool estado;
  final String Campo_1;
  final String Campo_2;
  final String Campo_3;
  final String Campo_4;
  final String Campo_5;
  final String Campo_6;
  final String Campo_7;
  final String Campo_8;

  PaBscEmpresa1M({
    required this.empresa,
    required this.empresaNombre,
    required this.razonSocial,
    required this.empresaNIT,
    required this.empresaDireccion,
    required this.numeroPatronal,
    required this.estado,
    required this.Campo_1,
    required this.Campo_2,
    required this.Campo_3,
    required this.Campo_4,
    required this.Campo_5,
    required this.Campo_6,
    required this.Campo_7,
    required this.Campo_8,
  });

  factory PaBscEmpresa1M.fromJson(Map<String, dynamic> json) {
    return PaBscEmpresa1M(
      empresa: json['empresa'],
      empresaNombre: json['empresa_Nombre'],
      razonSocial: json['razon_Social'],
      empresaNIT: json['empresa_NIT'],
      empresaDireccion: json['empresa_Direccion'],
      numeroPatronal: json['numero_Patronal'],
      estado: json['estado'],
      Campo_1: json['campo_1'],
      Campo_2: json['campo_2'],
      Campo_3: json['campo_3'],
      Campo_4: json['campo_4'],
      Campo_5: json['campo_5'],
      Campo_6: json['campo_6'],
      Campo_7: json['campo_7'],
      Campo_8: json['campo_8'],
    );
  }
}
