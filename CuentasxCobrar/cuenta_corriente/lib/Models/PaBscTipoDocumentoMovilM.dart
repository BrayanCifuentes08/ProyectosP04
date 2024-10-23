class PaBscTipoDocumentoMovilM {
  final int tipoDocumento;
  final String descripcion;
  final int cuentaCorriente;
  final int cargoAbono;
  final int contabilidad;
  final int documentoBancario;
  final int origenCuentaCorriente;
  final bool opcVerificar;
  final bool opcCuentaCorriente;
  final int ordenCuentaCorriente;

  PaBscTipoDocumentoMovilM({
    required this.tipoDocumento,
    required this.descripcion,
    required this.cuentaCorriente,
    required this.cargoAbono,
    required this.contabilidad,
    required this.documentoBancario,
    required this.origenCuentaCorriente,
    required this.opcVerificar,
    required this.opcCuentaCorriente,
    required this.ordenCuentaCorriente,
  });

  factory PaBscTipoDocumentoMovilM.fromJson(Map<String, dynamic> json) {
    return PaBscTipoDocumentoMovilM(
      tipoDocumento: json['tipo_Documento'],
      descripcion: json['descripcion'],
      cuentaCorriente: json['cuenta_Corriente'],
      cargoAbono: json['cargo_Abono'],
      contabilidad: json['contabilidad'],
      documentoBancario: json['documento_Bancario'],
      origenCuentaCorriente: json['origen_Cuenta_Corriente'],
      opcVerificar: json['opc_Verificar'],
      opcCuentaCorriente: json['opc_Cuenta_Corriente'],
      ordenCuentaCorriente: json['orden_Cuenta_Corriente'],
    );
  }
}
