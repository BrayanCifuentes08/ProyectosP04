export interface DocumentoAplicarParametros{
  pOpcion:                    number;
  pUserName:                  string;
  pTipo_Cambio:               number;
  pMoneda:                    number;
  pMensaje:                   string;
  pResultado:                 boolean;
  pDoc_CC_Documento:          number;
  pDoc_CC_Tipo_Documento:     number;
  pDoc_CC_Serie_Documento:    string;
  pDoc_CC_Empresa:            number;
  pDoc_CC_Localizacion:       number;
  pDoc_CC_Estacion_Trabajo:   number;
  pDoc_CC_Fecha_Reg:          number;
  pDoc_CC_Cuenta_Correntista: number;
  pDoc_CC_Cuenta_Cta:         string;
  pDoc_CC_Fecha_Documento:    Date;
  pCA_Monto_Total:            number;
  pTCA_Monto:                 boolean;
  pEstructura:                string;
  recaptchaToken:     string,
  isMobile:           boolean
}

export interface CuentaCorriente {
    CC_Cuenta_Corriente:   number;
    CC_Cobrar_Pagar?:       number;
    CC_Empresa:            number;
    CC_Localizacion:       number;
    CC_Estacion_Trabajo:   number;
    CC_Fecha_Reg:          number;
    CC_D_Documento?:        number | null;
    CC_D_Tipo_Documento?:   number | null;
    CC_D_Serie_Documento?:  string | null;
    CC_D_Empresa?:          number | null;
    CC_D_Localizacion?:     number | null;
    CC_D_Estacion_Trabajo?: string | null;
    CC_D_Fecha_Reg?:        number | null;
    CC_Monto:              number;
    CC_Monto_M:            number;
    CC_Cuenta_Correntista: number;
    CC_Cuenta_Cta:         string;
    recaptchaToken:     string,
    isMobile:           boolean
  }

  export interface Estructura {
    cuentaCorriente: CuentaCorriente[];
  }