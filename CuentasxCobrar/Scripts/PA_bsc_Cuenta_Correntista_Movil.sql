
--SP QUE BUSCA CLIENTES
--574122-k
DECLARE @RC int
DECLARE @pUserName varchar(30)                  = 'ds'
DECLARE @pCriterio_Busqueda varchar(200)        = 'Hilda'
DECLARE @pEmpresa tinyint                       = 1

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Cuenta_Correntista_Movil] 
                                                                                                           @pUserName
                                                                                                          ,@pCriterio_Busqueda
                                                                                                          ,@pEmpresa
GO
