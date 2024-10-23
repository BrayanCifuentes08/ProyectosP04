export interface PaBscSerieDocumento1M{
    tipo_Documento:       number;
    serie_Documento:      number;
    empresa:              number;
    bodega:               number;
    descripcion:          string;
    serie_Ini:            number
    serie_Fin:            number;
    estado:               boolean;
    campo01:              string;
    campo02:              string;
    campo03:              string;
    campo04:              string;
    campo05:              string;
    campo06:              string;
    campo07:              string;
    campo08:              string;
    campo09:              string;
    campo10:              string;
    documento_Disp:       number;
    documento_Aviso:      number;
    documento_Frecuencia: number;
    fecha_Hora:           Date;
    doc_Det:              number;
    limite_Impresion:     number;
    userName:             string;
    m_Fecha_Hora:         Date;
    m_UserName:           string;
    orden:                number;
    grupo:                number;
    opc_Venta:            boolean;
    bloquear_Imprimir:    boolean;
    des_Tipo_Documento:   string;

}


export interface ParametrosSerieDocumento{
    pTipo_Documento:      number;
    pEmpresa:             number;
    pEstacion_Trabajo:    number;
    pUserName:            string
    pT_Filtro_6:          boolean;
    pGrupo:               number;
    pDocumento_Conv:      boolean;
    pFE_Tipo:             boolean;
    pPOS_Tipo:            number;
    pVer_FE:              boolean;

}