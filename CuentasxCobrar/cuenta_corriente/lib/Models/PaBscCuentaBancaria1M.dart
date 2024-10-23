class PaBscCuentaBancaria1M {
  final int cuentaBancaria;
  final String? descripcion;
  final int banco;
  final String idCuentaBancaria;
  final double banIni;
  final double banIniMes;
  final int cuenta;
  final int numDoc;
  final double saldo;
  final bool estado;
  final String lugar;
  final double banIniDia;
  final DateTime fechaHora;
  final String userName;
  final DateTime? mFechaHora;
  final String? mUserName;
  final String? orden;
  final int serieIni;
  final int serieFin;
  final int moneda;
  final int? cuentaM;

  PaBscCuentaBancaria1M({
    required this.cuentaBancaria,
    required this.descripcion,
    required this.banco,
    required this.idCuentaBancaria,
    required this.banIni,
    required this.banIniMes,
    required this.cuenta,
    required this.numDoc,
    required this.saldo,
    required this.estado,
    required this.lugar,
    required this.banIniDia,
    required this.fechaHora,
    required this.userName,
    required this.mFechaHora,
    required this.mUserName,
    required this.orden,
    required this.serieIni,
    required this.serieFin,
    required this.moneda,
    required this.cuentaM,
  });

  factory PaBscCuentaBancaria1M.fromJson(Map<String, dynamic> json) {
    return PaBscCuentaBancaria1M(
      cuentaBancaria: json['cuenta_Bancaria'] as int,
      descripcion:
          json['descripcion'] == null ? null : json['descripcion'].toString(),
      banco: json['banco'] as int,
      idCuentaBancaria: json['id_Cuenta_Bancaria'],
      banIni: json['ban_Ini'].toDouble(),
      banIniMes: json['ban_Ini_Mes'].toDouble(),
      cuenta: json['cuenta'] as int,
      numDoc: json['num_Doc'] as int,
      saldo: json['saldo'].toDouble(),
      estado: json['estado'],
      lugar: json['lugar'],
      banIniDia: json['ban_Ini_Dia'].toDouble(),
      fechaHora: DateTime.parse(json['fecha_Hora']),
      userName: json['userName'],
      mFechaHora:
          DateTime.tryParse(json['m_Fecha_Hora'] ?? '') ?? DateTime.now(),
      mUserName:
          json['m_UserName'] == null ? null : json['m_UserName'].toString(),
      orden: json['orden'] == null ? null : json['orden'].toString(),
      serieIni: json['serie_Ini'],
      serieFin: json['serie_Fin'],
      moneda: json['moneda'],
      cuentaM: json['cuenta_M'] as int?,
    );
  }
}
