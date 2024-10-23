export interface PaBscTipoCargoAbono1M {
    tipo_Cargo_Abono:       number;
    descripcion:            string;
    monto:                  number;
    referencia:             number;
    autorizacion:           number;
    calcular_Monto:         number;
    cuenta_Corriente:       number;    
    reservacion:            boolean;
    factura:                boolean;
    efectivo:               boolean;
    banco:                  boolean;
    fecha_Vencimiento:      boolean;
    comision_Porcentaje:    number;
    comision_Monto:         number;
    cuenta?:                number;
    contabilizar:           boolean;
    val_Limite_Credito:     boolean;
    msg_Limite_Credito:     boolean;
    cuenta_Correntista?:    number;
    cuenta_Cta?:            Number;
    bloquear_Documento:     boolean;
    url:                    string;
    req_Cuenta_Bancaria?:   number;
    req_Fecha:              number;
    reqRefDocumento:        number;
    claveOriginal?: string;
}

    
export interface ParametrosTipoPago{
    pTipo_Documento:        number;
    pSerie_documento:       string;
    pEmpresa:               number;
}

