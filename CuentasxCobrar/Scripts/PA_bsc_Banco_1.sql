--SP BUSCA BANCOS POR EMPRESA

DECLARE @RC int
DECLARE @pUserName varchar(30)        = 'ds'
DECLARE @pEmpresa tinyint             = 1
DECLARE @pOpcion tinyint              = 4

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Banco_1] 
                                                                           @pUserName
                                                                          ,@pEmpresa
                                                                          ,@pOpcion