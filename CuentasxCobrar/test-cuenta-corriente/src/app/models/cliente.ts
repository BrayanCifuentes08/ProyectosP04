export interface PaBscCuentaCorrentistaMovilM {
    someField:              any;
    cuenta_Correntista:     number;
    cuenta_Cta:             string;
    factura_Nombre:         string;
    factura_Nit:            string;
    factura_Direccion:      string;
    cC_Direccion:           string;
    des_Cuenta_Cta:         string;
    direccion_1_Cuenta_Cta: string;
    email:                  string;
    telefono:               string;
    celular:                string;
    limite_Credito:         number;
    permitir_CxC:           boolean;
    grupo_Cuenta:           string;
    des_Grupo_Cuenta:       string;
}

export interface ParametrosCliente {
    pFacturaNom:            string;
    pFacturaNit:            string;
    pFacturaDireccion:      string;
    pCCDireccion:           string;
    pTelefono:              string;
}