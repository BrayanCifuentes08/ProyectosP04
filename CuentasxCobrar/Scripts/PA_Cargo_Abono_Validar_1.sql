
--Procedimiento que valida todas reglas de nogocios antes de generar una forma de pago.

USE [test_cuenta_corriente]
GO

DECLARE @RC int
DECLARE @pUserName varchar(30)                         = 'juan'       --login          
DECLARE @pCargo_Abono int                              = 0
DECLARE @pEmpresa tinyint                              = 1            --login
DECLARE @pLocalizacion smallint                        = 1
DECLARE @pEstacion_Trabajo smallint					   = 1            --login
DECLARE @pFecha_Reg int                                = 0
DECLARE @pD_Documento int                              = 7	          --Primeros 7 campos de [PA_tbl_Documento] --5	2	1	1	1	1561503
DECLARE @pD_Tipo_Documento tinyint                     = 5
DECLARE @pD_Serie_Documento varchar(5)                 = 2
DECLARE @pD_Empresa tinyint                            = 1
DECLARE @pD_Localizacion smallint                      = 1
DECLARE @pD_Estacion_Trabajo smallint                  = 1
DECLARE @pD_Fecha_Reg int                              = 1561503
DECLARE @pTipo_Cargo_Abono tinyint                     = 1            --dato ingresado por el usuario
DECLARE @pMonto numeric(18,2)                          = 1.1          --dato ingresado por el usuario
DECLARE @pMonto_Moneda numeric(18,2)                   = 1.1/7        --dato ingresado por el usuario monto/tipo_cambio
DECLARE @pTipo_Cambio numeric(18,2)                    = 7            --dato ingresado por el usuario
DECLARE @pMoneda tinyint                               = 1            --dato ingresado por el usuario
DECLARE @pMensaje varchar(200)                         = ''
DECLARE @pResultado bit                                = 1
DECLARE @pRef_Documento varchar(20)                    = ''           --dato ingresado por el usuario	 --el mismo de referencia 
DECLARE @pCuenta_Bancaria smallint                     = 1            --dato ingresado por el usuario
DECLARE @pReferencia varchar(50)                       = 1            --dato ingresado por el usuario    --el mismo de referencia 
DECLARE @pAutorizacion varchar(50)                     = ''           --dato ingresado por el usuario
DECLARE @pTrigger_Ins bit                              = 1
DECLARE @pVer_Tabla bit                                = 1
DECLARE @pRef_Fecha varchar(max)                       = ''           --dato ingresado por el usuario
DECLARE @pResultado_Opcion tinyint                     = 1
DECLARE @pBanco tinyint                                = 1            --dato ingresado por el usuario

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_Cargo_Abono_Validar_1] 
   @pUserName
  ,@pCargo_Abono
  ,@pEmpresa
  ,@pLocalizacion
  ,@pEstacion_Trabajo
  ,@pFecha_Reg
  ,@pD_Documento
  ,@pD_Tipo_Documento
  ,@pD_Serie_Documento
  ,@pD_Empresa
  ,@pD_Localizacion
  ,@pD_Estacion_Trabajo
  ,@pD_Fecha_Reg
  ,@pTipo_Cargo_Abono
  ,@pMonto
  ,@pMonto_Moneda
  ,@pTipo_Cambio
  ,@pMoneda
  ,@pMensaje OUTPUT
  ,@pResultado OUTPUT
  ,@pRef_Documento
  ,@pCuenta_Bancaria
  ,@pReferencia
  ,@pAutorizacion
  ,@pTrigger_Ins
  ,@pVer_Tabla
  ,@pRef_Fecha
  ,@pResultado_Opcion OUTPUT
  ,@pBanco


  select @pMensaje
  select @pResultado                                -- = 1 genera encabezado de documento, = 0 detener proceso y mostrar mensajes
GO


