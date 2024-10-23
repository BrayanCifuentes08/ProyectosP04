export interface PaBscCuentaBancaria1M {
    cuenta_Bancaria:    number;
    descripcion:        string;
    banco:              number;
    id_Cuenta_Bancaria: string;
    ban_Ini:            number;
    ban_Ini_Mes:        number;
    cuenta:             number;
    num_Doc:            number;
    saldo:              number;
    estado:             boolean;
    lugar:              string;
    ban_Ini_Dia:        number;
    fecha_Hora:         Date;
    userName:           string;
    m_Fecha_Hora:       Date;
    m_UserName:         string;
    orden:              string;
    serie_Ini:          number;
    serie_Fin:          number;
    moneda:             number;
    cuenta_M?:          number;
}

export interface ParametrosCuentaBancaria{
    pUserName:  string;
    pBanco:     number;
    pEmpresa:   number;
}
