export interface PaDocumentoValidar1M{
    mensaje:                  string;
    resultado:                boolean;
}

export interface ParametrosDocumentoValidar{
    pUserName:                string; 
    pDocumento:               number;
    pTipo_Documento:          number;
    pSerie_Documento:         string;
    pEmpresa:                 number;
    pLocalizacion:            number
    pEstacion_Trabajo:        number;
    pFecha_Reg:               number;
    pFecha_Documento:         string  | null;
    pCuenta_Correntista:      number;
    pCuenta_Cta:              string;
    pBloqueado:               boolean;
    pEstado_Objeto:           number;
    pMensaje:                 string;
    pResultado:               boolean;
    pElemento_Asignado?:      number  | null;
    pReferencia?:             number  | null;
    pId_Documento:            string;
    pRef_Serie?:              string  | null;
    pFecha_Vencimiento?:      Date    | null;
    pCuenta_Correntista_Ref?: number  | null;
    pAccion?:                 number  | null;
    pIVA_Exento?:             boolean | null;
    pRef_Id_Documento?:       string  | null;
    pResultado_Opcion?:       number  | null;
    pBodega_Origen?:          number  | null;
    pBodega_Destino?:         number  | null;
    pObservacion_1?:          string  | null;
    pObservacion_2?:          string  | null;
    pObservacion_3?:          string  | null;

}