class PaTblDocumentoM {
  final int? TAccion;
  final int? Documento;
  final int? Tipo_Documento;
  final String? Serie_Documento;
  final int? Empresa;
  final int? Localizacion;
  final int? Estacion_Trabajo;
  final int? Fecha_Reg;
  final DateTime Fecha_Hora;
  final String? UserName;
  final DateTime? M_Fecha_Hora;
  final String? M_UserName;
  final int? Cuenta_Correntista;
  final String? Cuenta_Cta;
  final String? Id_Documento;
  final String? Documento_Nombre;
  final String? Documento_NIT;
  final String? Documento_Direccion;
  final String? Id_Reservacion;
  final int? Bodega_Origen;
  final int? Bodega_Destino;
  final String? Observacion_1;
  final DateTime Fecha_Documento;
  final String? Observacion_2;
  final int? Elemento_Asignado;
  final int Estado_Documento;
  final int? Impresion_Doc;
  final int? Referencia;
  final String? Doc_Det;
  final DateTime? Fecha_Ini;
  final DateTime? Fecha_Fin;
  final DateTime? Fecha_Vencimiento;
  final bool? Per_O_Cargos;
  final int? Clasificacion;
  final int? Cierre;
  final DateTime? Fecha_Documento_Aux;
  final String? Ref_Serie;
  final bool? Contabilizado;
  final int? Turno;
  final String? Observacion_3;
  final int? Cuenta_Correntista_Ref;
  final double? Cambio;
  final double? Cambio_Moneda;
  final bool Bloqueado;
  final bool? Bloquear_Venta;
  final int? Razon;
  final int? Proceso;
  final int Consecutivo_Interno;
  final int? Cuenta_Correntista_Ref_2;
  final int? Localizacion_Ref;
  final int? Tipo_Pago;
  final double? Campo_1;
  final double? Campo_2;
  final double? Campo_3;
  final int? Fecha_Hora_N;
  final int? Fecha_Documento_N;
  final int? Seccion;
  final int? Tipo_Actividad;
  final int? Cierre_Contable;
  final String? Id_Unc;
  final bool? IVA_Exento;
  final int? TOpcion;
  final DateTime? Ref_Fecha_Documento;
  final DateTime? Ref_Fecha_Vencimiento;
  final double? T_Tra_M;
  final double? T_Tra_MM;
  final double? T_Car_Abo_M;
  final double? T_Car_Abo_MM;
  final double? Propina_Monto;
  final double? Propina_Monto_Moneda;
  final String? Ref_Id_Documento;
  final double? T_Tra_M_NImp;
  final double? T_Tra_MM_NImp;
  final double? T_Tra_M_Imp_IVA;
  final double? T_Tra_MM_Imp_IVA;
  final double? T_Tra_M_Imp_ITU;
  final double? T_Tra_MM_Imp_ITU;
  final double? T_Tra_M_Propina;
  final double? T_Tra_MM_Propina;
  final double? T_Tra_M_Cargo;
  final double? T_Tra_MM_Cargo;
  final double? T_Tra_M_Descuento;
  final double? T_Tra_MM_Descuento;
  final double? T_Car_Abo_M_Por_Aplicar;
  final double? T_Car_Abo_MM_Por_Aplicar;
  final double? T_Tra_M_Sub;
  final double? T_Tra_MM_Sub;
  final int? Vehiculo_Marca;
  final int? Vehiculo_Modelo;
  final int? Vehiculo_Year;
  final int? Vehiculo_Color;
  final int? Survey_Record;
  final int? Periodo;
  final int? Adults;
  final int? Childrens;
  final int? Id_Doc_Alt;
  final bool? ISR_Retener;
  final String? FE_Cae;
  final String? FE_numeroDocumento;
  final String? FE_numeroDte;
  final String? GPS_Latitud;
  final String? GPS_Longitud;
  final int? Consecutivo_Interno_Ref;
  final String? FEL_UUID_Anulacion;
  final int? FEL_Numero_Acceso;
  final String? FE_Fecha_Certificacion;
  final String? Id_Unc_Sync;
  final String? RecaptchaToken;
  final bool? isMobile;

  PaTblDocumentoM(
      {required this.TAccion,
      required this.Documento,
      required this.Tipo_Documento,
      required this.Serie_Documento,
      required this.Empresa,
      required this.Localizacion,
      required this.Estacion_Trabajo,
      required this.Fecha_Reg,
      required this.Fecha_Hora,
      required this.UserName,
      this.M_Fecha_Hora,
      this.M_UserName,
      required this.Cuenta_Correntista,
      required this.Cuenta_Cta,
      required this.Id_Documento,
      required this.Documento_Nombre,
      required this.Documento_NIT,
      required this.Documento_Direccion,
      this.Id_Reservacion,
      this.Bodega_Origen,
      this.Bodega_Destino,
      this.Observacion_1,
      required this.Fecha_Documento,
      this.Observacion_2,
      this.Elemento_Asignado,
      required this.Estado_Documento,
      this.Impresion_Doc,
      this.Referencia,
      this.Doc_Det,
      this.Fecha_Ini,
      this.Fecha_Fin,
      this.Fecha_Vencimiento,
      this.Per_O_Cargos,
      this.Clasificacion,
      this.Cierre,
      this.Fecha_Documento_Aux,
      this.Ref_Serie,
      this.Contabilizado,
      this.Turno,
      this.Observacion_3,
      this.Cuenta_Correntista_Ref,
      this.Cambio,
      this.Cambio_Moneda,
      required this.Bloqueado,
      this.Bloquear_Venta,
      this.Razon,
      this.Proceso,
      required this.Consecutivo_Interno,
      this.Cuenta_Correntista_Ref_2,
      this.Localizacion_Ref,
      this.Tipo_Pago,
      this.Campo_1,
      this.Campo_2,
      this.Campo_3,
      required this.Fecha_Hora_N,
      required this.Fecha_Documento_N,
      this.Seccion,
      this.Tipo_Actividad,
      this.Cierre_Contable,
      this.Id_Unc,
      this.IVA_Exento,
      required this.TOpcion,
      this.Ref_Fecha_Documento,
      this.Ref_Fecha_Vencimiento,
      this.T_Tra_M,
      this.T_Tra_MM,
      this.T_Car_Abo_M,
      this.T_Car_Abo_MM,
      this.Propina_Monto,
      this.Propina_Monto_Moneda,
      this.Ref_Id_Documento,
      this.T_Tra_M_NImp,
      this.T_Tra_MM_NImp,
      this.T_Tra_M_Imp_IVA,
      this.T_Tra_MM_Imp_IVA,
      this.T_Tra_M_Imp_ITU,
      this.T_Tra_MM_Imp_ITU,
      this.T_Tra_M_Propina,
      this.T_Tra_MM_Propina,
      this.T_Tra_M_Cargo,
      this.T_Tra_MM_Cargo,
      this.T_Tra_M_Descuento,
      this.T_Tra_MM_Descuento,
      this.T_Car_Abo_M_Por_Aplicar,
      this.T_Car_Abo_MM_Por_Aplicar,
      this.T_Tra_M_Sub,
      this.T_Tra_MM_Sub,
      this.Vehiculo_Marca,
      this.Vehiculo_Modelo,
      this.Vehiculo_Year,
      this.Vehiculo_Color,
      this.Survey_Record,
      this.Periodo,
      this.Adults,
      this.Childrens,
      this.Id_Doc_Alt,
      this.ISR_Retener,
      this.FE_Cae,
      this.FE_numeroDocumento,
      this.FE_numeroDte,
      this.GPS_Latitud,
      this.GPS_Longitud,
      this.Consecutivo_Interno_Ref,
      this.FEL_UUID_Anulacion,
      this.FEL_Numero_Acceso,
      this.FE_Fecha_Certificacion,
      this.Id_Unc_Sync,
      this.RecaptchaToken,
      this.isMobile});

  factory PaTblDocumentoM.fromJson(Map<String, dynamic> json) {
    return PaTblDocumentoM(
      TAccion: json['tAccion'] != null
          ? int.tryParse(json['tAccion'].toString())
          : null,
      Documento: json['documento'] != null
          ? int.tryParse(json['documento'].toString())
          : null,
      Tipo_Documento: json['tipo_Documento'] != null
          ? int.tryParse(json['tipo_Documento'].toString())
          : null,
      Serie_Documento: json['serie_Documento'],
      Empresa: json['empresa'] != null
          ? int.tryParse(json['empresa'].toString())
          : null,
      Localizacion: json['localizacion'] != null
          ? int.tryParse(json['localizacion'].toString())
          : null,
      Estacion_Trabajo: json['estacion_Trabajo'] != null
          ? int.tryParse(json['estacion_Trabajo'].toString())
          : null,
      Fecha_Reg: json['fecha_Reg'] != null
          ? int.tryParse(json['fecha_Reg'].toString())
          : null,
      Fecha_Hora: DateTime.parse(json['fecha_Hora']),
      UserName: json['userName'],
      M_Fecha_Hora: json['m_Fecha_Hora'] != null
          ? DateTime.parse(json['m_Fecha_Hora'])
          : null,
      M_UserName: json['m_UserName'] ?? '',
      Cuenta_Correntista: json['cuenta_Correntista'] != null
          ? int.tryParse(json['cuenta_Correntista'].toString())
          : null,
      Cuenta_Cta: json['cuenta_Cta'].toString(),
      Id_Documento: json['id_Documento'],
      Documento_Nombre: json['documento_Nombre'],
      Documento_NIT: json['documento_NIT'],
      Documento_Direccion: json['documento_Direccion'],
      Id_Reservacion: json['id_Reservacion'] ?? '',
      Bodega_Origen: json['bodega_Origen'] != null
          ? int.tryParse(json['bodega_Origen'].toString())
          : null,
      Bodega_Destino: json['bodega_Destino'] != null
          ? int.tryParse(json['bodega_Destino'].toString())
          : null,
      Observacion_1: json['observacion_1'] ?? '',
      Fecha_Documento: DateTime.parse(json['fecha_Documento']),
      Observacion_2: json['observacion_2'] ?? '',
      Elemento_Asignado: json['elemento_Asignado'] != null
          ? int.tryParse(json['elemento_Asignado'].toString())
          : null,
      Estado_Documento: json['estado_Documento'],
      Impresion_Doc: json['impresion_Doc'],
      Referencia: json['referencia'] as int?,
      Doc_Det: json['doc_Det'] ?? '',
      Fecha_Ini:
          json['fecha_Ini'] != null ? DateTime.parse(json['fecha_Ini']) : null,
      Fecha_Fin:
          json['fecha_Fin'] != null ? DateTime.parse(json['fecha_Fin']) : null,
      Fecha_Vencimiento: json['fecha_Vencimiento'] != null
          ? DateTime.parse(json['fecha_Vencimiento'])
          : null,
      Per_O_Cargos: json['per_O_Cargos'] ?? false,
      Clasificacion: json['clasificacion'],
      Cierre: json['cierre'],
      Fecha_Documento_Aux: json['fecha_Documento_Aux'] != null
          ? DateTime.parse(json['fecha_Documento_Aux'])
          : null,
      Ref_Serie: json['ref_Serie'] ?? '',
      Contabilizado: json['contabilizado'] ?? false,
      Turno: json['turno'],
      Observacion_3: json['observacion_3'] ?? '',
      Cuenta_Correntista_Ref: json['cuenta_Correntista_Ref'],
      Cambio: json['cambio']?.toDouble(),
      Cambio_Moneda: json['cambio_Moneda']?.toDouble(),
      Bloqueado: json['bloqueado'] ?? false,
      Bloquear_Venta: json['bloquear_Venta'] ?? false,
      Razon: json['razon'],
      Proceso: json['proceso'],
      Consecutivo_Interno: json['consecutivo_Interno'],
      Cuenta_Correntista_Ref_2: json['cuenta_Correntista_Ref_2'],
      Localizacion_Ref: json['localizacion_Ref'],
      Tipo_Pago: json['tipo_Pago'],
      Campo_1: json['campo_1']?.toDouble(),
      Campo_2: json['campo_2']?.toDouble(),
      Campo_3: json['campo_3']?.toDouble(),
      Fecha_Hora_N: json['fecha_Hora_N'],
      Fecha_Documento_N: json['fecha_Documento_N'],
      Seccion: json['seccion'],
      Tipo_Actividad: json['tipo_Actividad'],
      Cierre_Contable: json['cierre_Contable'],
      Id_Unc: json['id_Unc'] ?? '',
      IVA_Exento: json['ivA_Exento'] ?? false,
      TOpcion: json['tOpcion'],
      Ref_Fecha_Documento: json['ref_Fecha_Documento'] != null
          ? DateTime.parse(json['ref_Fecha_Documento'])
          : null,
      Ref_Fecha_Vencimiento: json['ref_Fecha_Vencimiento'] != null
          ? DateTime.parse(json['ref_Fecha_Vencimiento'])
          : null,
      T_Tra_M: json['t_Tra_M']?.toDouble(),
      T_Tra_MM: json['t_Tra_MM']?.toDouble(),
      T_Car_Abo_M: json['t_Car_Abo_M']?.toDouble(),
      T_Car_Abo_MM: json['t_Car_Abo_MM']?.toDouble(),
      Propina_Monto: json['propina_Monto']?.toDouble(),
      Propina_Monto_Moneda: json['propina_Monto_Moneda']?.toDouble(),
      Ref_Id_Documento: json['ref_Id_Documento'] ?? '',
      T_Tra_M_NImp: json['t_Tra_M_NImp']?.toDouble(),
      T_Tra_MM_NImp: json['t_Tra_MM_NImp']?.toDouble(),
      T_Tra_M_Imp_IVA: json['t_Tra_M_Imp_IVA']?.toDouble(),
      T_Tra_MM_Imp_IVA: json['t_Tra_MM_Imp_IVA']?.toDouble(),
      T_Tra_M_Imp_ITU: json['t_Tra_M_Imp_ITU']?.toDouble(),
      T_Tra_MM_Imp_ITU: json['t_Tra_MM_Imp_ITU']?.toDouble(),
      T_Tra_M_Propina: json['t_Tra_M_Propina']?.toDouble(),
      T_Tra_MM_Propina: json['t_Tra_MM_Propina']?.toDouble(),
      T_Tra_M_Cargo: json['t_Tra_M_Cargo']?.toDouble(),
      T_Tra_MM_Cargo: json['t_Tra_MM_Cargo']?.toDouble(),
      T_Tra_M_Descuento: json['t_Tra_M_Descuento']?.toDouble(),
      T_Tra_MM_Descuento: json['t_Tra_MM_Descuento']?.toDouble(),
      T_Car_Abo_M_Por_Aplicar: json['t_Car_Abo_M_Por_Aplicar']?.toDouble(),
      T_Car_Abo_MM_Por_Aplicar: json['t_Car_Abo_MM_Por_Aplicar']?.toDouble(),
      T_Tra_M_Sub: json['t_Tra_M_Sub']?.toDouble(),
      T_Tra_MM_Sub: json['t_Tra_MM_Sub']?.toDouble(),
      Vehiculo_Marca: json['vehiculo_Marca'],
      Vehiculo_Modelo: json['vehiculo_Modelo'],
      Vehiculo_Year: json['vehiculo_Year'],
      Vehiculo_Color: json['vehiculo_Color'],
      Survey_Record: json['survey_Record'],
      Periodo: json['periodo'],
      Adults: json['adults'],
      Childrens: json['childrens'],
      Id_Doc_Alt: json['id_Doc_Alt'],
      ISR_Retener: json['isR_Retener'] ?? false,
      FE_Cae: json['fE_Cae'] ?? '',
      FE_numeroDocumento: json['fE_numeroDocumento'] ?? '',
      FE_numeroDte: json['fE_numeroDte'] ?? '',
      GPS_Latitud: json['gpS_Latitud'] ?? '',
      GPS_Longitud: json['gpS_Longitud'] ?? '',
      Consecutivo_Interno_Ref: json['consecutivo_Interno_Ref'],
      FEL_UUID_Anulacion: json['feL_UUID_Anulacion'] ?? '',
      FEL_Numero_Acceso: json['feL_Numero_Acceso'],
      FE_Fecha_Certificacion: json['fE_Fecha_Certificacion'] ?? '',
      Id_Unc_Sync: json['id_Unc_Sync'] ?? '',
      RecaptchaToken: json['recaptchaToken'] ?? '',
      isMobile: json['isMobile'] ?? true,
    );
  }
}
