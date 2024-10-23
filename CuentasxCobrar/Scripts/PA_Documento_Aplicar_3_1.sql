
DECLARE @RC int                                                                          
DECLARE @pOpcion int                                          = 1
DECLARE @pUserName varchar(30)                                = 'ds'
DECLARE @pTipo_Cambio numeric(18,6)                           = 7
DECLARE @pMoneda tinyint                                      = 1
DECLARE @pMensaje varchar(200)                                = ''
DECLARE @pResultado bit                                       = 1
DECLARE @pDoc_CC_Documento int                                = 12							--datos del recibo
DECLARE @pDoc_CC_Tipo_Documento int                           = 5							--datos del recibo
DECLARE @pDoc_CC_Serie_Documento varchar(5)                   = '35'						--datos del recibo
DECLARE @pDoc_CC_Empresa int                                  = 1							--datos del recibo
DECLARE @pDoc_CC_Localizacion int                             = 1							--datos del recibo
DECLARE @pDoc_CC_Estacion_Trabajo int                         = 1							--datos del recibo
DECLARE @pDoc_CC_Fecha_Reg int                                = 1561532						--datos del recibo
DECLARE @pDoc_CC_Cuenta_Correntista int                       = 12							--datos del recibo
DECLARE @pDoc_CC_Cuenta_Cta varchar(5)                        = '1'							--datos del recibo
DECLARE @pDoc_CC_Fecha_Documento datetime                     = '2024-07-24T16:12:47.937'	--datos del recibo
DECLARE @pCA_Monto_Total numeric(18,2)                        = 27581						--total de todos los cargos abonos
DECLARE @pTCA_Monto bit                                       = 1							--datos del recibo  --tipo de documento --0 resta --1 suma
DECLARE @pEstructura varchar(max)                                                =  '{
  "CuentaCorriente": [
    {
      "CC_Cuenta_Corriente": 13,
      "CC_Cobrar_Pagar": 1,
      "CC_Empresa": 1,
      "CC_Localizacion": 1,
      "CC_Estacion_Trabajo": 2,
      "CC_Fecha_Reg": 1018824,
      "CC_D_Documento": 12,			
      "CC_D_Tipo_Documento": 5,		
      "CC_D_Serie_Documento": "35", 
      "CC_D_Empresa": 1,			 
      "CC_D_Localizacion": 1,		
      "CC_D_Estacion_Trabajo": 1,	
      "CC_D_Fecha_Reg": 1561532,	
      "CC_Monto": 19479.79,			
      "CC_Monto_M": 2434.97,
      "CC_Cuenta_Correntista": 12,
      "CC_Cuenta_Cta": "1"
    },
	{
      "CC_Cuenta_Corriente": 26,
      "CC_Cobrar_Pagar": 1,
      "CC_Empresa": 1,
      "CC_Localizacion": 1,
      "CC_Estacion_Trabajo": 2,
      "CC_Fecha_Reg": 1561449,
      "CC_D_Documento": 12,
      "CC_D_Tipo_Documento": 5,
      "CC_D_Serie_Documento": "35",
      "CC_D_Empresa": 1,
      "CC_D_Localizacion": 1,
      "CC_D_Estacion_Trabajo": 1,
      "CC_D_Fecha_Reg": 1561532,
      "CC_Monto": 8101.21,
      "CC_Monto_M": 1157.31,
      "CC_Cuenta_Correntista": 12,
      "CC_Cuenta_Cta": "1"
    }
  ]
}'


-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_Documento_Aplicar_3_1] 
   @pOpcion
  ,@pUserName
  ,@pTipo_Cambio		
  ,@pMoneda
  ,@pMensaje OUTPUT
  ,@pResultado OUTPUT
  ,@pDoc_CC_Documento
  ,@pDoc_CC_Tipo_Documento
  ,@pDoc_CC_Serie_Documento
  ,@pDoc_CC_Empresa
  ,@pDoc_CC_Localizacion
  ,@pDoc_CC_Estacion_Trabajo
  ,@pDoc_CC_Fecha_Reg
  ,@pDoc_CC_Cuenta_Correntista
  ,@pDoc_CC_Cuenta_Cta
  ,@pDoc_CC_Fecha_Documento
  ,@pCA_Monto_Total
  ,@pTCA_Monto
  ,@pEstructura
GO


 