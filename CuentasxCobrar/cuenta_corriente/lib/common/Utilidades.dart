import 'package:flutter/material.dart';
import 'package:test_cuenta_corriente/generated/l10n.dart';

class DocumentoTraduccion {
  // Función para traducir los tipos de documento
  static String traducirTipoDocumento(
      String descripcion, BuildContext context) {
    final Map<String, String> traducciones = {
      'Abono CxC': S.of(context).abonoCxC,
      'Cargo CxC': S.of(context).cargoCxC,
      'Nota de Credito CxC': S.of(context).notaCreditoCxC,
      'Nota de Debito CxC': S.of(context).notaDebitoCxC,
      'Recibo de Caja CxC': S.of(context).reciboCajaCxC,
    };

    if (traducciones.containsKey(descripcion)) {
      return traducciones[descripcion]!;
    } else {
      return descripcion; // Si no coincide, devuelve la descripción original
    }
  }

  static String traducirTipoPago(String descripcion, BuildContext context) {
    final Map<String, String> traducciones = {
      'Efectivo (CxC)': S.of(context).efectivoCxC,
      'Tarjeta de Credito (CxC)': S.of(context).tarjetaCreditoCxC,
      'Cheque (CxC)': S.of(context).chequeCxC,
      'Exenciones de IVA': S.of(context).exencionesIVA,
      'Nota de Debito (CxP)': S.of(context).notaDebitoCP,
      'Nota de Credito (CxC)': S.of(context).notaCreditoCxCPago,
      'Retenciones IVA': S.of(context).retencionesIVA,
      'Devoluciones': S.of(context).devoluciones,
      'Abono (CxC)': S.of(context).abonoCxCPago,
      'Cargo (CxC)': S.of(context).cargoCxCPago,
    };

    if (traducciones.containsKey(descripcion)) {
      return traducciones[descripcion]!;
    } else {
      return descripcion; // Si no coincide, devuelve la descripción original
    }
  }
}
