class PaTblCargoAbonoM {
  int? TAccion;
  int Cargo_Abono;
  int Empresa;
  int Localizacion;
  int Estacion_Trabajo;
  int Fecha_Reg;
  int Tipo_Cargo_Abono;
  int Estado;
  DateTime Fecha_Hora;
  String UserName;
  DateTime? M_Fecha_Hora;
  String? M_UserName;
  double Monto;
  double Tipo_Cambio;
  int Moneda;
  double Monto_Moneda;
  String? Referencia;
  String? Autorizacion;
  int? Banco;
  String? Observacion_1;
  int? Razon;
  int? D_Documento;
  int D_Tipo_Documento;
  String D_Serie_Documento;
  int D_Empresa;
  int D_Localizacion;
  int D_Estacion_Trabajo;
  int D_Fecha_Reg;
  double? Propina;
  double? Propina_Moneda;
  double? Monto_O;
  double? Monto_O_Moneda;
  int? F_Cuenta_Corriente_Padre;
  int? F_Cobrar_Pagar_Padre;
  int? F_Empresa_Padre;
  int? F_Localizacion_Padre;
  int? F_Estacion_Trabajo_Padre;
  int? F_Fecha_Reg_Padre;
  String? Ref_Documento;
  int? Cuenta_Bancaria;
  double? Propina_Monto;
  double? Propina_Monto_Moneda;
  int? Cuenta_PIN;
  int? TOpcion;
  DateTime? Fecha_Ref;
  int? Consecutivo_Interno_Ref;
  final String? RecaptchaToken;
  final bool? isMobile;
  PaTblCargoAbonoM({
    required this.TAccion,
    required this.Cargo_Abono,
    required this.Empresa,
    required this.Localizacion,
    required this.Estacion_Trabajo,
    required this.Fecha_Reg,
    required this.Tipo_Cargo_Abono,
    required this.Estado,
    required this.Fecha_Hora,
    required this.UserName,
    required this.M_Fecha_Hora,
    required this.M_UserName,
    required this.Monto,
    required this.Tipo_Cambio,
    required this.Moneda,
    required this.Monto_Moneda,
    required this.Referencia,
    required this.Autorizacion,
    required this.Banco,
    required this.Observacion_1,
    required this.Razon,
    required this.D_Documento,
    required this.D_Tipo_Documento,
    required this.D_Serie_Documento,
    required this.D_Empresa,
    required this.D_Localizacion,
    required this.D_Estacion_Trabajo,
    required this.D_Fecha_Reg,
    required this.Propina,
    required this.Propina_Moneda,
    required this.Monto_O,
    required this.Monto_O_Moneda,
    required this.F_Cuenta_Corriente_Padre,
    required this.F_Cobrar_Pagar_Padre,
    required this.F_Empresa_Padre,
    required this.F_Localizacion_Padre,
    required this.F_Estacion_Trabajo_Padre,
    required this.F_Fecha_Reg_Padre,
    required this.Ref_Documento,
    required this.Cuenta_Bancaria,
    required this.Propina_Monto,
    required this.Propina_Monto_Moneda,
    required this.Cuenta_PIN,
    required this.TOpcion,
    required this.Fecha_Ref,
    required this.Consecutivo_Interno_Ref,
    this.RecaptchaToken,
    this.isMobile,
  });
  factory PaTblCargoAbonoM.fromJson(Map<String, dynamic> json) {
    return PaTblCargoAbonoM(
      TAccion: json['tAccion'] != null
          ? int.tryParse(json['tAccion'].toString())
          : null,
      Cargo_Abono: json['cargo_Abono'],
      Empresa: json['empresa'],
      Localizacion: json['localizacion'],
      Estacion_Trabajo: json['estacion_Trabajo'],
      Fecha_Reg: json['fecha_Reg'],
      Tipo_Cargo_Abono: json['tipo_Cargo_Abono'],
      Estado: json['estado'],
      Fecha_Hora: DateTime.parse(json['fecha_Hora']),
      UserName: json['userName'] ?? '',
      M_Fecha_Hora: json['m_Fecha_Hora'] != null
          ? DateTime.parse(json['m_Fecha_Hora'])
          : null,
      M_UserName: json['m_UserName'] ?? '',
      Monto: json['monto'],
      Tipo_Cambio: json['tipo_Cambio'],
      Moneda: json['moneda'],
      Monto_Moneda: json['monto_Moneda'],
      Referencia: json['referencia'] ?? '',
      Autorizacion: json['autorizacion'] ?? '',
      Banco: json['banco'] as int?,
      Observacion_1: json['observacion_1'] ?? '',
      Razon: json['razon'] as int?,
      D_Documento: json['d_Documento'],
      D_Tipo_Documento: json['d_Tipo_Documento'],
      D_Serie_Documento: json['d_Serie_Documento'] ?? '',
      D_Empresa: json['d_Empresa'],
      D_Localizacion: json['d_Localizacion'],
      D_Estacion_Trabajo: json['d_Estacion_Trabajo'],
      D_Fecha_Reg: json['d_Fecha_Reg'],
      Propina: json['propina']?.toDouble() ?? 0.0,
      Propina_Moneda: json['propina_Moneda']?.toDouble() ?? 0.0,
      Monto_O: json['monto_O']?.toDouble() ?? 0.0,
      Monto_O_Moneda: json['monto_O_Moneda']?.toDouble() ?? 0.0,
      F_Cuenta_Corriente_Padre: json['f_Cuenta_Corriente_Padre'],
      F_Cobrar_Pagar_Padre: json['f_Cobrar_Pagar_Padre'],
      F_Empresa_Padre: json['f_Empresa_Padre'],
      F_Localizacion_Padre: json['f_Localizacion_Padre'],
      F_Estacion_Trabajo_Padre: json['f_Estacion_Trabajo_Padre'],
      F_Fecha_Reg_Padre: json['f_Fecha_Reg_Padre'],
      Ref_Documento: json['ref_Documento'] ?? '',
      Cuenta_Bancaria: json['cuenta_Bancaria'] as int?,
      Propina_Monto: json['propina_Monto']?.toDouble() ?? 0.0,
      Propina_Monto_Moneda: json['propina_Monto_Moneda']?.toDouble() ?? 0.0,
      Cuenta_PIN: json['cuenta_PIN']?.toDouble(),
      TOpcion: json['tOpcion'] as int?,
      Fecha_Ref:
          json['fecha_Ref'] != null ? DateTime.parse(json['fecha_Ref']) : null,
      Consecutivo_Interno_Ref: json['consecutivo_Interno_Ref'] as int?,
      RecaptchaToken: json['recaptchaToken'] ?? '',
      isMobile: json['isMobile'] ?? true,
    );
  }
}
