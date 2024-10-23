--Procedemiento para insertar pago(cargo_abono) a un documento
USE [test_cuenta_corriente]
GO

DECLARE @RC int
DECLARE @TAccion tinyint                                           = 1
DECLARE @pCargo_Abono int                                          = 0
DECLARE @pEmpresa tinyint                                          = 1
DECLARE @pLocalizacion smallint                                    = 1
DECLARE @pEstacion_Trabajo int                                     = 1
DECLARE @pFecha_Reg int                                            = 0
DECLARE @pTipo_Cargo_Abono tinyint                                 = 5			--dato ingresado por el usuario
DECLARE @pEstado tinyint                                           = 1
DECLARE @pFecha_Hora datetime                                      = GETDATE()
DECLARE @pUserName varchar(30)                                     = 'DS'
DECLARE @pM_Fecha_Hora datetime                                    = null
DECLARE @pM_UserName varchar(30)                                   = null
DECLARE @pMonto numeric(18,2)                                      = 1.1		--dato ingresado por el usuario 
DECLARE @pTipo_Cambio numeric(18,6)                                = 7			--dato ingresado por el usuario -De donde viene? --empresa moneda
DECLARE @pMoneda tinyint                                           = 1			--dato ingresado por el usuario -De donde viene? --empresa moneda
DECLARE @pMonto_Moneda numeric(18,6)                               = 1.1/7      
DECLARE @pReferencia varchar(50)                                   = 'dasda'	--dato ingresado por el usuario
DECLARE @pAutorizacion varchar(50)                                 = 'dasda'	--dato ingresado por el usuario
DECLARE @pBanco tinyint                                            = 1			--dato ingresado por el usuario
DECLARE @pObservacion_1 varchar(500)                               = 'dasda'	--dato ingresado por el usuario
DECLARE @pRazon tinyint                                            = null
DECLARE @pD_Documento int                                          = 9          --llave del documento 7        5        2        1        1        1        1561503      
DECLARE @pD_Tipo_Documento tinyint                                 = 5          --llave del documento
DECLARE @pD_Serie_Documento varchar(5)                             = 2          --llave del documento
DECLARE @pD_Empresa tinyint                                        = 1          --llave del documento
DECLARE @pD_Localizacion smallint                                  = 1          --llave del documento
DECLARE @pD_Estacion_Trabajo smallint                              = 1          --llave del documento
DECLARE @pD_Fecha_Reg int                                          = 1561503    --llave del documento
DECLARE @pPropina numeric(18,2)                                    = null
DECLARE @pPropina_Moneda numeric(18,2)                             = null
DECLARE @pMonto_O numeric(18,6)                                    = null
DECLARE @pMonto_O_Moneda numeric(18,6)                             = null
DECLARE @pF_Cuenta_Corriente_Padre int                             = null        --segunda fase
DECLARE @pF_Cobrar_Pagar_Padre tinyint                             = null        --segunda fase
DECLARE @pF_Empresa_Padre tinyint                                  = null        --segunda fase
DECLARE @pF_Localizacion_Padre smallint                            = null        --segunda fase
DECLARE @pF_Estacion_Trabajo_Padre smallint                        = null        --segunda fase
DECLARE @pF_Fecha_Reg_Padre int                                    = null        --segunda fase
DECLARE @pRef_Documento varchar(20)                                = ''          --mismo de referencia
DECLARE @pCuenta_Bancaria smallint                                 = 1			 --dato ingresado por el usuario
DECLARE @pPropina_Monto numeric(18,6)                              = null
DECLARE @pPropina_Monto_Moneda numeric(18,6)                       = null
DECLARE @pCuenta_PIN int                                           = null
DECLARE @TOpcion tinyint                                           = 1
DECLARE @pFecha_Ref datetime                                       = getDate()   --dato ingresado por el usuario
DECLARE @pConsecutivo_Interno_Ref bigint                           = null

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_tbl_Cargo_Abono] 
   @TAccion
  ,@pCargo_Abono OUTPUT
  ,@pEmpresa
  ,@pLocalizacion
  ,@pEstacion_Trabajo
  ,@pFecha_Reg OUTPUT
  ,@pTipo_Cargo_Abono
  ,@pEstado
  ,@pFecha_Hora
  ,@pUserName
  ,@pM_Fecha_Hora
  ,@pM_UserName
  ,@pMonto
  ,@pTipo_Cambio
  ,@pMoneda
  ,@pMonto_Moneda
  ,@pReferencia
  ,@pAutorizacion
  ,@pBanco
  ,@pObservacion_1
  ,@pRazon
  ,@pD_Documento
  ,@pD_Tipo_Documento
  ,@pD_Serie_Documento
  ,@pD_Empresa
  ,@pD_Localizacion
  ,@pD_Estacion_Trabajo
  ,@pD_Fecha_Reg
  ,@pPropina
  ,@pPropina_Moneda
  ,@pMonto_O
  ,@pMonto_O_Moneda
  ,@pF_Cuenta_Corriente_Padre
  ,@pF_Cobrar_Pagar_Padre
  ,@pF_Empresa_Padre
  ,@pF_Localizacion_Padre
  ,@pF_Estacion_Trabajo_Padre
  ,@pF_Fecha_Reg_Padre
  ,@pRef_Documento
  ,@pCuenta_Bancaria
  ,@pPropina_Monto
  ,@pPropina_Monto_Moneda
  ,@pCuenta_PIN
  ,@TOpcion
  ,@pFecha_Ref
  ,@pConsecutivo_Interno_Ref
GO


