

DECLARE @RC int
DECLARE @TAccion tinyint                                = 1
DECLARE @TOpcion tinyint                                = 1
DECLARE @pConsecutivo_Interno bigint					= 0
--DECLARE @pEstructura text                             = 'Estructura JSON'
DECLARE @pEstructura varchar(max)	                    = 'Estructura JSON' --varchar(max) debe ser tipo de dato text para que soporte mas contenido aqui se cambio a varchar por temas de sintaxis
DECLARE @pUserName varchar(30)                          = 'ds'
DECLARE @pFecha_Hora datetime                           = getdate()
DECLARE @pTipo_Estructura tinyint                       = 1
DECLARE @pEstado tinyint                                = 1
DECLARE @pM_UserName varchar(1)                         = null
DECLARE @pM_Fecha_Hora datetime                         = null
DECLARE @pId_Unc uniqueidentifier                       = null

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_tbl_Documento_Estructura] 
   @TAccion
  ,@TOpcion
  ,@pConsecutivo_Interno OUTPUT
  ,@pEstructura
  ,@pUserName
  ,@pFecha_Hora
  ,@pTipo_Estructura
  ,@pEstado
  ,@pM_UserName
  ,@pM_Fecha_Hora
  ,@pId_Unc OUTPUT
GO


