--Esta procedimiento valida reglas de negocio antes de crear documento(encabezado)
USE [test_cuenta_corriente]
GO

DECLARE @RC int
DECLARE @pUserName varchar(30)                                = 'juan' 
DECLARE @pDocumento int                                       = 0
DECLARE @pTipo_Documento tinyint                              = 5        --dato ingresado por el usuario
DECLARE @pSerie_Documento varchar(5)                          = 2        --dato ingresado por el usuario
DECLARE @pEmpresa tinyint                                     = 1
DECLARE @pLocalizacion smallint                               = 1
DECLARE @pEstacion_Trabajo smallint                           = 1
DECLARE @pFecha_Reg int                                       = 0
DECLARE @pFecha_Documento datetime                            = getdate()--dato ingresado por el usuario
DECLARE @pCuenta_Correntista int                              = 12       --dato ingresado por el usuario
DECLARE @pCuenta_Cta varchar(20)                              = 1        --dato ingresado por el usuario
DECLARE @pBloqueado bit                                       = 0
DECLARE @pEstado_Objeto tinyint                               = 1
DECLARE @pMensaje varchar(200)                                = ''
DECLARE @pResultado bit                                       = 1
DECLARE @pElemento_Asignado smallint                          = null
DECLARE @pReferencia int                                      = null
DECLARE @pId_Documento varchar(20)                            = '231321' --De donde viene?
DECLARE @pRef_Serie varchar(30)                               = null
DECLARE @pFecha_Vencimiento datetime                          = null
DECLARE @pCuenta_Correntista_Ref int                          = null
DECLARE @pAccion tinyint                                      = 0
DECLARE @pIVA_Exento bit                                      = null
DECLARE @pRef_Id_Documento varchar(20)                        = null
DECLARE @pResultado_Opcion tinyint                            = null
DECLARE @pBodega_Origen smallint                              = null
DECLARE @pBodega_Destino smallint                             = null
DECLARE @pObservacion_1 varchar(200)                          = null
DECLARE @pObservacion_2 varchar(200)                          = null
DECLARE @pObservacion_3 varchar(200)                          = null

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_Documento_Validar_1] 
   @pUserName
  ,@pDocumento
  ,@pTipo_Documento
  ,@pSerie_Documento
  ,@pEmpresa
  ,@pLocalizacion
  ,@pEstacion_Trabajo
  ,@pFecha_Reg
  ,@pFecha_Documento
  ,@pCuenta_Correntista
  ,@pCuenta_Cta
  ,@pBloqueado
  ,@pEstado_Objeto
  ,@pMensaje OUTPUT
  ,@pResultado OUTPUT
  ,@pElemento_Asignado
  ,@pReferencia
  ,@pId_Documento
  ,@pRef_Serie
  ,@pFecha_Vencimiento
  ,@pCuenta_Correntista_Ref
  ,@pAccion
  ,@pIVA_Exento
  ,@pRef_Id_Documento
  ,@pResultado_Opcion OUTPUT
  ,@pBodega_Origen
  ,@pBodega_Destino
  ,@pObservacion_1
  ,@pObservacion_2
  ,@pObservacion_3


  select @pMensaje
  select @pResultado  -- = 1 genera encabezado de documento, = 0 detener proceso y mostrar mensajes
GO


