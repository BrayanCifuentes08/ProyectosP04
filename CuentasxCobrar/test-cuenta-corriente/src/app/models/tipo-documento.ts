
export interface PaBscTipoDocumentoMovilM{
    tipo_Documento:          number;
    descripcion:             string;
    cuenta_Corriente:        number;
    cargo_Abono:             number;
    contabilidad:            number;
    documento_Bancario:      number;
    origen_Cuenta_Corriente: number;
    opc_Verificar:           boolean;
    opc_Cuenta_Corriente:    boolean;
    orden_Cuenta_Corriente:  number;
    claveOriginal?: string
}

export interface ParametrosTipoDocumento{
    pUserName:               string;
    pOpc_Cuenta_Corriente:   boolean;
    pCuenta_Corriente:       boolean
    pEmpresa:                number;
    pIngreso:                boolean;
    pCosto:                  boolean;

}