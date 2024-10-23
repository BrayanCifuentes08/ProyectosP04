use test_cuenta_corriente

DECLARE @RC int
DECLARE @pUserName varchar(30)        = 'AUDITOR01'

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Empresa_1] 
   @pUserName
GO


