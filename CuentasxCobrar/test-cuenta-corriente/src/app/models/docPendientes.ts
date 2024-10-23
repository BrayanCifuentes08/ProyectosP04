

export interface PaBscCuentaCorriente1M {
    Consecutivo_Interno:        number;
    R_UserName:                 string;
    Cuenta_Corriente:           number;
    Cobrar_Pagar:               number;
    Empresa:                    number;
    Localizacion:               number;
    Estacion_Trabajo:           number;
    Fecha_Reg:                  number;
    Estado:                     boolean;
    Fecha_Hora:                 Date;
    UserName:                   string;
    M_Fecha_Hora:               Date;
    M_UserName:                 string;
    Cuenta_Correntista:         number;
    Cuenta_Cta:                 string;
    Monto:                      number;
    Tipo_Cambio:                number;
    Moneda:                     number;
    Monto_Moneda:               number;
    Cuenta_Corriente_Padre:     number;
    Cobrar_Pagar_Padre:         number;
    Empresa_Padre:              number;
    Localizacion_Padre:         number;
    Estacion_Trabajo_Padre:     number;
    Fecha_Reg_Padre:            number;
    Fecha_Cuenta:               Date;
    Fecha_Inicial:              Date;
    Fecha_Final:                Date;
    Generar_Cheque:             string;
    Proceso:                    string;
    Cuenta_Bancaria:            string;
    Id_Documento_Referencia:    string;
    Saldo:                      number;
    Saldo_Moneda:               number;
    Cuenta_Correntista_Ref:     number;
    Valor_Aplicado:             number;
    Valor_Aplicado_Moneda:      number;
    Id_Documento:               string;
    Fecha_Documento:            Date;
    Des_Serie_Documento:        string;
    Nom_Moneda:                 string;
    Des_Moneda:                 string;
    Simbolo:                    string;
    Des_Estado_Documento:       string;
    Factura_Nombre:             string;
    Des_Cuenta_Cta:             string;
    Des_Tipo_Documento:         string;
    fDocumento_Relacion:        string;
    Des_Cuenta_Corriente:       string;
    D_Documento:                number;
    D_Tipo_Documento:           number;
    D_Serie_Documento:          string;
    D_Empresa:                  number;
    D_Localizacion:             number;
    D_Estacion_Trabajo:         number;
    D_Fecha_Reg:                number;
    Referencia:                 number;
    Ref_Id_Documento:           number;
    Ref_Serie:                  number;
    Documento_Nombre:           string;
    Id_Cuenta:                  string;
    D_Referencia:               string;
    R_Referencia_Id:            string;
    R_Id_Documento_Origen:      string;
    D_Fecha_Vencimiento:        Date;
    FE_Cae:                     string;
    FE_NumeroDocumento:         string;
    aplicar:                    number;
    saldoRestante?:             number;
    valorAplicadoAnteriormente: number;
}

export interface Parametros {
    pCuenta_Correntista:        number;
    pCuenta_Cta:                string;
    pEmpresa:                   number;
    pCobrar_Pagar:              number;
    pSaldo:                     boolean;
    pReferencia?:               number;
    pFil_Documento_Relacion:    string;
    pUserName:                  string;
    pTotal_Monto?:              number;
    pTotal_Aplicado?:           number;
    pTotal_Saldo?:              number;
    pSel_Monto?:                number;
    pSel_Aplicado?:             number;
    pSel_Saldo?:                number;
    pOpcion_Orden:              number;
    pSQL_str:                   string;
    pFecha_Documento?:          number;
    pFacturaNom:                string;
    pFacturaNit:                string;
    pFacturaDireccion:          string;
    pCCDireccion:               string;
    pTelefono:                  string;
    
}


export interface ParametrosCliente {
    pFacturaNom:        string;
    pFacturaNit:        string;
    pFacturaDireccion:  string;
    pCCDireccion:       string;
    pTelefono:          string;
}