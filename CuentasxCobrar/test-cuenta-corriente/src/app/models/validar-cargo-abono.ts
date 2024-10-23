export interface PaCargoAbonoValidar1M{
    mensaje:    string;
    resultado:  boolean;
}

export interface ParametrosCargoAbonoValidar{
    pUserName:          string;
    pCargo_Abono:       number;
    pEmpresa:           number;
    pLocalizacion:      number;
    pEstacion_Trabajo:  number;
    pFecha_Reg:         number;
    pD_Documento:       number;
    pDTipo_Documento:   number;
    pD_Serie_Documento: string;
    pD_Empresa:         number;
    pD_Localizacion:    number;
    pD_Estacion_Trabajo:number;
    pD_Fecha_Reg:       number;
    pTipo_Cargo_Abono?: number | null;
    pMonto:             number;
    pMonto_Moneda:      number;
    pTipo_Cambio:       number;
    pMoneda?:           number | null;
    pMensaje?:          string | null;
    pResultado?:        boolean | null; 
    pRef_Documento?:    string | null; 
    pCuenta_Bancaria?:  number | null; 
    pReferencia?:       string | null;
    pAutorizacion?:     string | null;
    pTrigger_Ins:       boolean;
    pVer_Tabla:         boolean;
    pRef_Fecha?:        string | null;
    pResultado_Opcion?: number | null; 
    pBanco?:            number | null; 
}