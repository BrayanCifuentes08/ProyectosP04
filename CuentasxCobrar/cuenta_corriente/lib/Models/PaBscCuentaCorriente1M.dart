class PaBscCuentaCorriente1M {
  final int consecutivoInterno;
  final String rUserName;
  final int cuentaCorriente;
  final int cobrarPagar;
  final int empresa;
  final int localizacion;
  final int estacionTrabajo;
  final int fechaReg;
  final int estado;
  final String userName;
  final String? mUserName;
  final int cuentaCorrentista;
  final String cuentaCta;
  final int moneda;
  final int? cuentaCorrientePadre;
  final int? cobrarPagarPadre;
  final int? empresaPadre;
  final int? localizacionPadre;
  final int? estacionTrabajoPadre;
  final int? fechaRegPadre;
  final bool? generarCheque;
  final int? proceso;
  final int? cuentaBancaria;
  final int? idDocumentoReferencia;
  final int? cuentaCorrentistaRef;
  final String idDocumento;
  final String desSerieDocumento;
  final String nomMoneda;
  final String desMoneda;
  final String simbolo;
  final String desEstadoDocumento;
  final String facturaNombre;
  final String desCuentaCta;
  final String desTipoDocumento;
  final String fDocumentoRelacion;
  final String? desCuentaCorriente;
  final int dDocumento;
  final int dTipoDocumento;
  final String dSerieDocumento;
  final int dEmpresa;
  final int dLocalizacion;
  final int dEstacionTrabajo;
  final int dFechaReg;
  final String? referencia;
  final int? refIdDocumento;
  final String? refSerie;
  final String documentoNombre;
  final String idCuenta;
  final String? dReferencia;
  final int? rReferenciaId;
  final int? rIdDocumentoOrigen;
  final String feCae;
  final String feNumeroDocumento;
  final double saldoMoneda;
  final double valorAplicado;
  final double valorAplicadoMoneda;
  double aplicar;
  final double saldo;
  final double monto;
  final double montoMoneda;
  final double tipoCambio;
  final DateTime? mFechaHora;
  final DateTime fechaCuenta;
  final DateTime fechaHora;
  final DateTime? fechaInicial;
  final DateTime? fechaFinal;
  final DateTime fechaDocumento;
  final DateTime dFechaVencimiento;
  bool isExpanded;

  PaBscCuentaCorriente1M({
    required this.consecutivoInterno,
    required this.rUserName,
    required this.cuentaCorriente,
    required this.cobrarPagar,
    required this.empresa,
    required this.localizacion,
    required this.estacionTrabajo,
    required this.fechaReg,
    required this.estado,
    required this.userName,
    this.mUserName,
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.moneda,
    this.cuentaCorrientePadre,
    this.cobrarPagarPadre,
    this.empresaPadre,
    this.localizacionPadre,
    this.estacionTrabajoPadre,
    this.fechaRegPadre,
    this.generarCheque,
    this.proceso,
    this.cuentaBancaria,
    this.idDocumentoReferencia,
    required this.idDocumento,
    this.cuentaCorrentistaRef,
    required this.desSerieDocumento,
    required this.nomMoneda,
    required this.desMoneda,
    required this.simbolo,
    required this.desEstadoDocumento,
    required this.facturaNombre,
    required this.desCuentaCta,
    required this.desTipoDocumento,
    required this.fDocumentoRelacion,
    this.desCuentaCorriente,
    required this.dDocumento,
    required this.dTipoDocumento,
    required this.dSerieDocumento,
    required this.dEmpresa,
    required this.dLocalizacion,
    required this.dEstacionTrabajo,
    required this.dFechaReg,
    this.referencia,
    this.refIdDocumento,
    this.refSerie,
    required this.documentoNombre,
    required this.idCuenta,
    this.dReferencia,
    this.rReferenciaId,
    this.rIdDocumentoOrigen,
    required this.feCae,
    required this.feNumeroDocumento,
    required this.saldoMoneda,
    required this.valorAplicado,
    required this.valorAplicadoMoneda,
    required this.aplicar,
    required this.saldo,
    required this.monto,
    required this.montoMoneda,
    required this.tipoCambio,
    this.mFechaHora,
    required this.fechaCuenta,
    required this.fechaHora,
    this.fechaInicial,
    this.fechaFinal,
    required this.fechaDocumento,
    required this.dFechaVencimiento,
    this.isExpanded = false,
  });

  factory PaBscCuentaCorriente1M.fromJson(Map<String, dynamic> json) {
    return PaBscCuentaCorriente1M(
      consecutivoInterno: json['Consecutivo_Interno'],
      rUserName: json['R_UserName'],
      cuentaCorriente: json['Cuenta_Corriente'],
      cobrarPagar: json['Cobrar_Pagar'],
      empresa: json['Empresa'],
      localizacion: json['Localizacion'],
      estacionTrabajo: json['Estacion_Trabajo'],
      fechaReg: json['Fecha_Reg'],
      estado: json['Estado'],
      userName: json['UserName'],
      mUserName: json['M_UserName'],
      cuentaCorrentista: json['Cuenta_Correntista'],
      cuentaCta: json['Cuenta_Cta'],
      moneda: json['Moneda'],
      cuentaCorrientePadre: json['Cuenta_Corriente_Padre'],
      cobrarPagarPadre: json['Cobrar_Pagar_Padre'],
      empresaPadre: json['Empresa_Padre'],
      localizacionPadre: json['Localizacion_Padre'],
      estacionTrabajoPadre: json['Estacion_Trabajo_Padre'],
      fechaRegPadre: json['Fecha_Reg_Padre'],
      generarCheque: json['Generar_Cheque'],
      proceso: json['Proceso'],
      cuentaBancaria: json['Cuenta_Bancaria'],
      idDocumentoReferencia: json['Id_Documento_Referencia'],
      idDocumento: json['Id_Documento'],
      cuentaCorrentistaRef: json['Cuenta_Correntista_Ref'],
      desSerieDocumento: json['Des_Serie_Documento'],
      nomMoneda: json['Nom_Moneda'],
      desMoneda: json['Des_Moneda'],
      simbolo: json['Simbolo'],
      desEstadoDocumento: json['Des_Estado_Documento'],
      facturaNombre: json['Factura_Nombre'],
      desCuentaCta: json['Des_Cuenta_Cta'],
      desTipoDocumento: json['Des_Tipo_Documento'],
      fDocumentoRelacion: json['fDocumento_Relacion'],
      desCuentaCorriente: json['Des_Cuenta_Corriente'],
      dDocumento: json['D_Documento'],
      dTipoDocumento: json['D_Tipo_Documento'],
      dSerieDocumento: json['D_Serie_Documento'],
      dEmpresa: json['D_Empresa'],
      dLocalizacion: json['D_Localizacion'],
      dEstacionTrabajo: json['D_Estacion_Trabajo'],
      dFechaReg: json['D_Fecha_Reg'],
      referencia: json['Referencia'],
      refIdDocumento: json['Ref_Id_Documento'],
      refSerie: json['Ref_Serie'],
      documentoNombre: json['Documento_Nombre'],
      idCuenta: json['Id_Cuenta'],
      dReferencia: json['D_Referencia'],
      rReferenciaId: json['R_Referencia_Id'],
      rIdDocumentoOrigen: json['R_Id_Documento_Origen'],
      feCae: json['FE_Cae'],
      feNumeroDocumento: json['FE_NumeroDocumento'],
      saldoMoneda: (json['Saldo_Moneda'] ?? 0).toDouble(),
      valorAplicado: (json['Valor_Aplicado'] ?? 0).toDouble(),
      valorAplicadoMoneda: (json['Valor_Aplicado_Moneda'] ?? 0).toDouble(),
      aplicar: (json['Saldo'] ?? 0).toDouble(),
      saldo: (json['Saldo'] ?? 0).toDouble(),
      monto: (json['Monto'] ?? 0).toDouble(),
      montoMoneda: (json['Monto_Moneda'] ?? 0).toDouble(),
      tipoCambio: (json['Tipo_Cambio'] ?? 0).toDouble(),
      mFechaHora:
          DateTime.tryParse(json['M_Fecha_Hora'] ?? '') ?? DateTime.now(),
      fechaCuenta:
          DateTime.tryParse(json['Fecha_Cuenta'] ?? '') ?? DateTime.now(),
      fechaHora: DateTime.tryParse(json['Fecha_Hora'] ?? '') ?? DateTime.now(),
      fechaInicial:
          DateTime.tryParse(json['Fecha_Inicial'] ?? '') ?? DateTime.now(),
      fechaFinal:
          DateTime.tryParse(json['Fecha_Final'] ?? '') ?? DateTime.now(),
      fechaDocumento:
          DateTime.tryParse(json['Fecha_Documento'] ?? '') ?? DateTime.now(),
      dFechaVencimiento: DateTime.tryParse(json['D_Fecha_Vencimiento'] ?? '') ??
          DateTime.now(),
      isExpanded: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Consecutivo_Interno': consecutivoInterno,
      'R_UserName': rUserName,
      'Cuenta_Corriente': cuentaCorriente,
      'Cobrar_Pagar': cobrarPagar,
      'Empresa': empresa,
      'Localizacion': localizacion,
      'Estacion_Trabajo': estacionTrabajo,
      'Fecha_Reg': fechaReg,
      'Estado': estado,
      'UserName': userName,
      'M_UserName': mUserName,
      'Cuenta_Correntista': cuentaCorrentista,
      'Cuenta_Cta': cuentaCta,
      'Moneda': moneda,
      'Cuenta_Corriente_Padre': cuentaCorrientePadre,
      'Cobrar_Pagar_Padre': cobrarPagarPadre,
      'Empresa_Padre': empresaPadre,
      'Localizacion_Padre': localizacionPadre,
      'Estacion_Trabajo_Padre': estacionTrabajoPadre,
      'Fecha_Reg_Padre': fechaRegPadre,
      'Generar_Cheque': generarCheque,
      'Proceso': proceso,
      'Cuenta_Bancaria': cuentaBancaria,
      'Id_Documento_Referencia': idDocumentoReferencia,
      'Id_Documento': idDocumento,
      'Cuenta_Correntista_Ref': cuentaCorrentistaRef,
      'Des_Serie_Documento': desSerieDocumento,
      'Nom_Moneda': nomMoneda,
      'Des_Moneda': desMoneda,
      'Simbolo': simbolo,
      'Des_Estado_Documento': desEstadoDocumento,
      'Factura_Nombre': facturaNombre,
      'Des_Cuenta_Cta': desCuentaCta,
      'Des_Tipo_Documento': desTipoDocumento,
      'fDocumento_Relacion': fDocumentoRelacion,
      'Des_Cuenta_Corriente': desCuentaCorriente,
      'D_Documento': dDocumento,
      'D_Tipo_Documento': dTipoDocumento,
      'D_Serie_Documento': dSerieDocumento,
      'D_Empresa': dEmpresa,
      'D_Localizacion': dLocalizacion,
      'D_Estacion_Trabajo': dEstacionTrabajo,
      'D_Fecha_Reg': dFechaReg,
      'Referencia': referencia,
      'Ref_Id_Documento': refIdDocumento,
      'Ref_Serie': refSerie,
      'Documento_Nombre': documentoNombre,
      'Id_Cuenta': idCuenta,
      'D_Referencia': dReferencia,
      'R_Referencia_Id': rReferenciaId,
      'R_Id_Documento_Origen': rIdDocumentoOrigen,
      'FE_Cae': feCae,
      'FE_NumeroDocumento': feNumeroDocumento,
      'Saldo_Moneda': saldoMoneda,
      'Valor_Aplicado': valorAplicado,
      'Valor_Aplicado_Moneda': valorAplicadoMoneda,
      'Saldo': saldo,
      'Monto': monto,
      'Monto_Moneda': montoMoneda,
      'Tipo_Cambio': tipoCambio,
      'M_Fecha_Hora': mFechaHora,
      'Fecha_Cuenta': fechaCuenta,
      'Fecha_Hora': fechaHora,
      'Fecha_Inicial': fechaInicial,
      'Fecha_Final': fechaFinal,
      'Fecha_Documento': fechaDocumento,
      'D_Fecha_Vencimiento': dFechaVencimiento,
      'isExpanded': isExpanded,
    };
  }
}
