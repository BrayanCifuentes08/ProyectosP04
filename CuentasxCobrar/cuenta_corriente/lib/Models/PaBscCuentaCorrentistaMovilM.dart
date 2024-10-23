class PaBscCuentaCorrentistaMovilM {
  final int cuenta_Correntista;
  final String cuentaCta;
  final String facturaNombre;
  final String facturaNit;
  final String facturaDireccion;
  final String ccDireccion;
  final String desCuentaCta;
  final String direccion1CuentaCta;
  final String email;
  final String telefono;
  final String celular;
  final double limiteCredito;
  final bool permitirCxC;
  final String grupoCuenta;
  final String desGrupoCuenta;

  PaBscCuentaCorrentistaMovilM({
    required this.cuenta_Correntista,
    required this.cuentaCta,
    required this.facturaNombre,
    required this.facturaNit,
    required this.facturaDireccion,
    required this.ccDireccion,
    required this.desCuentaCta,
    required this.direccion1CuentaCta,
    required this.email,
    required this.telefono,
    required this.celular,
    required this.limiteCredito,
    required this.permitirCxC,
    required this.grupoCuenta,
    required this.desGrupoCuenta,
  });

  factory PaBscCuentaCorrentistaMovilM.fromJson(Map<String, dynamic> json) {
    return PaBscCuentaCorrentistaMovilM(
      cuenta_Correntista: json[
          'cuenta_Correntista'], //Cambiar campos y agregar campos que se desean mostrar en la tabla, los nombres tienen que ser identicos a los de la base de datos
      cuentaCta: json['cuenta_Cta'],
      facturaNombre: json['factura_Nombre'],
      facturaNit: json['factura_Nit'],
      facturaDireccion: json['factura_Direccion'],
      ccDireccion: json['cC_Direccion'],
      desCuentaCta: json['des_Cuenta_Cta'],
      direccion1CuentaCta: json['direccion_1_Cuenta_Cta'],
      email: json['email'],
      telefono: json['telefono'],
      celular: json['celular'],
      limiteCredito: json['limite_Credito'].toDouble(),
      permitirCxC: json['permitir_CxC'],
      grupoCuenta: json['grupo_Cuenta'],
      desGrupoCuenta: json['des_Grupo_Cuenta'],
    );
  }
}
