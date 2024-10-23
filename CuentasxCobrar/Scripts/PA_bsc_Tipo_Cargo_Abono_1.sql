

--OBTIENE FORMAS DE PAGO DISPONIBLES PARA DETERMINADO TIPO DE DOCUMENTO SEGUN LA SERIE DE DOCUMENTO Y LA EMPRESA

DECLARE @RC int
DECLARE @pTipo_Documento tinyint                    = 5
DECLARE @pSerie_Documento varchar(5)                = 1
DECLARE @pEmpresa tinyint                           = 1

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Tipo_Cargo_Abono_1] 
                                                                                           @pTipo_Documento
                                                                                          ,@pSerie_Documento
                                                                                          ,@pEmpresa

