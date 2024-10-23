class PaBscSerieDocumento1M {
  int tipoDocumento;
  int serieDocumento;
  int empresa;
  int bodega;
  String descripcion;
  double serieIni;
  double serieFin;
  int documentoDisp;
  int? documentoAviso;
  int? documentoFrecuencia;
  int? docDet;
  int? limiteImpresion;
  int? orden;
  int grupo;
  String userName;
  String? mUserName;
  bool? opcVenta; // Hacerlo opcional
  bool bloquearImprimir;
  String desTipoDocumento;
  DateTime fechaHora;
  DateTime? mFechaHora;
  bool? estado;
  String? campo01;
  String? campo02;
  String? campo03;
  String? campo04;
  String? campo05;
  String? campo06;
  String? campo07;
  String? campo08;
  String? campo09;
  String? campo10;

  PaBscSerieDocumento1M({
    required this.tipoDocumento,
    required this.serieDocumento,
    required this.empresa,
    required this.bodega,
    required this.descripcion,
    required this.serieIni,
    required this.serieFin,
    required this.documentoDisp,
    required this.documentoAviso,
    required this.documentoFrecuencia,
    required this.docDet,
    required this.limiteImpresion,
    required this.orden,
    required this.grupo,
    required this.userName,
    required this.mUserName,
    required this.opcVenta,
    required this.bloquearImprimir,
    required this.desTipoDocumento,
    required this.fechaHora,
    required this.mFechaHora,
    required this.estado,
    required this.campo01,
    required this.campo02,
    required this.campo03,
    required this.campo04,
    required this.campo05,
    required this.campo06,
    required this.campo07,
    required this.campo08,
    required this.campo09,
    required this.campo10,
  });

  factory PaBscSerieDocumento1M.fromJson(Map<String, dynamic> json) {
    return PaBscSerieDocumento1M(
      tipoDocumento: json['tipo_Documento'],
      serieDocumento: json['serie_Documento'],
      empresa: json['empresa'],
      bodega: json['bodega'],
      descripcion: json['descripcion'],
      serieIni: json['serie_Ini'].toDouble(),
      serieFin: json['serie_Fin'].toDouble(),
      documentoDisp: json['documento_Disp'],
      documentoAviso: json['documento_Aviso'],
      documentoFrecuencia: json['documento_Frecuencia'],
      docDet: json['doc_Det'] as int?,
      limiteImpresion: json['limite_Impresion'] as int?,
      orden: json['orden'] as int?,
      grupo: json['grupo'],
      userName: json['userName'],
      mUserName:
          json['m_UserName'] == null ? null : json['m_UserName'].toString(),
      opcVenta: json['opc_Venta'] == null ? null : json['opc_Venta'],
      bloquearImprimir: json['bloquear_Imprimir'] ?? false,
      desTipoDocumento: json['des_Tipo_Documento'],
      fechaHora: DateTime.parse(json['fecha_Hora']),
      mFechaHora: DateTime.parse(json['m_Fecha_Hora']),
      estado: json['estado'] == null ? null : json['estado'],
      campo01: json['campo01'] == null ? null : json['campo01'].toString(),
      campo02: json['campo02'] == null ? null : json['campo02'].toString(),
      campo03: json['campo03'] == null ? null : json['campo03'].toString(),
      campo04: json['campo04'] == null ? null : json['campo04'].toString(),
      campo05: json['campo05'] == null ? null : json['campo05'].toString(),
      campo06: json['campo06'] == null ? null : json['campo06'].toString(),
      campo07: json['campo07'] == null ? null : json['campo07'].toString(),
      campo08: json['campo08'] == null ? null : json['campo08'].toString(),
      campo09: json['campo09'] == null ? null : json['campo09'].toString(),
      campo10: json['campo10'] == null ? null : json['campo10'].toString(),
    );
  }
}
