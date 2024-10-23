class DocumentoAplicarParametros {
  int pOpcion;
  String pUserName;
  double pTipoCambio;
  int pMoneda;
  String pMensaje;
  bool pResultado;
  int? pDocCCDocumento;
  int? pDocCCTipoDocumento;
  String? pDocCCSerieDocumento;
  int? pDocCCEmpresa;
  int? pDocCCLocalizacion;
  int? pDocCCEstacionTrabajo;
  int? pDocCCFechaReg;
  int? pDocCCCuentaCorrentista;
  String? pDocCCCuentaCta;
  DateTime? pDocCCFechaDocumento;
  double pCAMontoTotal;
  bool? pTCAMonto;
  Estructura pEstructura;
  String? recaptchaToken;
  bool? isMobile;

  DocumentoAplicarParametros({
    required this.pOpcion,
    required this.pUserName,
    required this.pTipoCambio,
    required this.pMoneda,
    required this.pMensaje,
    required this.pResultado,
    required this.pDocCCDocumento,
    required this.pDocCCTipoDocumento,
    required this.pDocCCSerieDocumento,
    required this.pDocCCEmpresa,
    required this.pDocCCLocalizacion,
    required this.pDocCCEstacionTrabajo,
    required this.pDocCCFechaReg,
    required this.pDocCCCuentaCorrentista,
    required this.pDocCCCuentaCta,
    required this.pDocCCFechaDocumento,
    required this.pCAMontoTotal,
    required this.pTCAMonto,
    required this.pEstructura,
    this.recaptchaToken,
    this.isMobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'pOpcion': pOpcion,
      'pUserName': pUserName,
      'pTipo_Cambio': pTipoCambio,
      'pMoneda': pMoneda,
      'pMensaje': pMensaje,
      'pResultado': pResultado,
      'pDoc_CC_Documento': pDocCCDocumento,
      'pDoc_CC_Tipo_Documento': pDocCCTipoDocumento,
      'pDoc_CC_Serie_Documento': pDocCCSerieDocumento,
      'pDoc_CC_Empresa': pDocCCEmpresa,
      'pDoc_CC_Localizacion': pDocCCLocalizacion,
      'pDoc_CC_Estacion_Trabajo': pDocCCEstacionTrabajo,
      'pDoc_CC_Fecha_Reg': pDocCCFechaReg,
      'pDoc_CC_Cuenta_Correntista': pDocCCCuentaCorrentista,
      'pDoc_CC_Cuenta_Cta': pDocCCCuentaCta,
      'pDoc_CC_Fecha_Documento': pDocCCFechaDocumento?.toIso8601String(),
      'pCA_Monto_Total': pCAMontoTotal,
      'pTCA_Monto': pTCAMonto,
      'pEstructura': pEstructura.toJson(),
      'recaptchaToken': recaptchaToken,
      'isMobile': isMobile,
    };
  }
}

class Estructura {
  List<CuentaCorriente> cuentaCorriente;

  Estructura({required this.cuentaCorriente});

  Map<String, dynamic> toJson() {
    return {
      'CuentaCorriente': cuentaCorriente.map((e) => e.toJson()).toList(),
    };
  }
}

class CuentaCorriente {
  int cCCuentaCorriente;
  int cCCobrarPagar;
  int cCEmpresa;
  int cCLocalizacion;
  int cCEstacionTrabajo;
  int cCFechaReg;
  int? cCDDocumento;
  int? cCDTipoDocumento;
  String? cCDSerieDocumento;
  int? cCDEmpresa;
  int? cCDLocalizacion;
  int? cCDEstacionTrabajo;
  int? cCDFechaReg;
  double cCMonto;
  double cCMontoM;
  int cCCuentaCorrentista;
  String cCCuentaCta;

  CuentaCorriente({
    required this.cCCuentaCorriente,
    required this.cCCobrarPagar,
    required this.cCEmpresa,
    required this.cCLocalizacion,
    required this.cCEstacionTrabajo,
    required this.cCFechaReg,
    required this.cCDDocumento,
    required this.cCDTipoDocumento,
    required this.cCDSerieDocumento,
    required this.cCDEmpresa,
    required this.cCDLocalizacion,
    required this.cCDEstacionTrabajo,
    required this.cCDFechaReg,
    required this.cCMonto,
    required this.cCMontoM,
    required this.cCCuentaCorrentista,
    required this.cCCuentaCta,
  });

  Map<String, dynamic> toJson() {
    return {
      'CC_Cuenta_Corriente': cCCuentaCorriente,
      'CC_Cobrar_Pagar': cCCobrarPagar,
      'CC_Empresa': cCEmpresa,
      'CC_Localizacion': cCLocalizacion,
      'CC_Estacion_Trabajo': cCEstacionTrabajo,
      'CC_Fecha_Reg': cCFechaReg,
      'CC_D_Documento': cCDDocumento,
      'CC_D_Tipo_Documento': cCDTipoDocumento,
      'CC_D_Serie_Documento': cCDSerieDocumento,
      'CC_D_Empresa': cCDEmpresa,
      'CC_D_Localizacion': cCDLocalizacion,
      'CC_D_Estacion_Trabajo': cCDEstacionTrabajo,
      'CC_D_Fecha_Reg': cCDFechaReg,
      'CC_Monto': cCMonto,
      'CC_Monto_M': cCMontoM,
      'CC_Cuenta_Correntista': cCCuentaCorrentista,
      'CC_Cuenta_Cta': cCCuentaCta,
    };
  }
}
