class PaBscTipoCargoAbono1M {
  int tipoCargoAbono;
  String descripcion;
  double monto;
  int referencia;
  int autorizacion;
  double calcularMonto;
  int cuentaCorriente;
  bool reservacion;
  bool factura;
  bool efectivo;
  bool banco;
  bool fechaVencimiento;
  double comisionPorcentaje;
  double comisionMonto;
  int? cuenta;
  bool contabilizar;
  bool valLimiteCredito;
  bool msgLimiteCredito;
  int? cuentaCorrentista;
  int? cuentaCta;
  bool bloquearDocumento;
  String? url;
  int? reqCuentaBancaria;
  int? reqRefDocumento;
  int? reqFecha;

  PaBscTipoCargoAbono1M({
    required this.tipoCargoAbono,
    required this.descripcion,
    required this.monto,
    required this.referencia,
    required this.autorizacion,
    required this.calcularMonto,
    required this.cuentaCorriente,
    required this.reservacion,
    required this.factura,
    required this.efectivo,
    required this.banco,
    required this.fechaVencimiento,
    required this.comisionPorcentaje,
    required this.comisionMonto,
    this.cuenta,
    required this.contabilizar,
    required this.valLimiteCredito,
    required this.msgLimiteCredito,
    this.cuentaCorrentista,
    this.cuentaCta,
    required this.bloquearDocumento,
    required this.url,
    this.reqCuentaBancaria,
    this.reqRefDocumento,
    this.reqFecha,
  });

  factory PaBscTipoCargoAbono1M.fromJson(Map<String, dynamic> json) {
    return PaBscTipoCargoAbono1M(
      tipoCargoAbono: json['tipo_Cargo_Abono'],
      descripcion: json['descripcion'],
      monto: json['monto'].toDouble(),
      referencia: json['referencia'],
      autorizacion: json['autorizacion'],
      calcularMonto: json['calcular_Monto'].toDouble(),
      cuentaCorriente: json['cuenta_Corriente'],
      reservacion: json['reservacion'],
      factura: json['factura'],
      efectivo: json['efectivo'],
      banco: json['banco'],
      fechaVencimiento: json['fecha_Vencimiento'],
      comisionPorcentaje: json['comision_Porcentaje'].toDouble(),
      comisionMonto: json['comision_Monto'].toDouble(),
      cuenta: json['cuenta'],
      contabilizar: json['contabilizar'],
      valLimiteCredito: json['val_Limite_Credito'],
      msgLimiteCredito: json['msg_Limite_Credito'],
      cuentaCorrentista: json['cuenta_Correntista'],
      cuentaCta: json['cuenta_Cta'],
      bloquearDocumento: json['bloquear_Documento'],
      url: json['url'],
      reqCuentaBancaria: json['req_Cuenta_Bancaria'],
      reqRefDocumento: json['req_Ref_Documento'],
      reqFecha: json['req_Fecha'],
    );
  }
}
