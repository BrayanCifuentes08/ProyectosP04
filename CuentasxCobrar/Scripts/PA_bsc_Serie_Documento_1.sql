--SP PARA OBTENER LOS DATOS DE LA SERIE DE DOCUMENTO

DECLARE @RC int
DECLARE @pTipo_Documento tinyint                = 15
DECLARE @pEmpresa tinyint                                = 1
DECLARE @pEstacion_Trabajo smallint                = 1
DECLARE @pUserName varchar(30)                        = 'ds'
DECLARE @pT_Filtro_6 bit                                = 0 
DECLARE @pGrupo tinyint                                        = 1
DECLARE @pDocumento_Conv bit                        = 0
DECLARE @pFE_Tipo bit                                        = 0
DECLARE @pPOS_Tipo tinyint                                = 0
DECLARE @pVer_FE bit                                        = 1

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Serie_Documento_1] 
                                                                                                   @pTipo_Documento
                                                                                                  ,@pEmpresa
                                                                                                  ,@pEstacion_Trabajo
                                                                                                  ,@pUserName
                                                                                                  ,@pT_Filtro_6
                                                                                                  ,@pGrupo
                                                                                                  ,@pDocumento_Conv
                                                                                                  ,@pFE_Tipo
                                                                                                  ,@pPOS_Tipo
                                                                                                  ,@pVer_FE
GO