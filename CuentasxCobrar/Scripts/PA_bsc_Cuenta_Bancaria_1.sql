--SP BUSCA CUENTAS BANCARIAS POR BANCO

DECLARE @RC int
DECLARE @pUserName varchar(30)        = 'ds'
DECLARE @pEmpresa tinyint             = 1
DECLARE @pBanco tinyint               = 9

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Cuenta_Bancaria_1] 
                                                                                           @pUserName
                                                                                          ,@pEmpresa
                                                                                          ,@pBanco



