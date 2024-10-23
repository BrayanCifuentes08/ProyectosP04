use test_cuenta_corriente
GO

DECLARE @RC int
DECLARE @pUserName varchar(30)        = 'AUDITOR01'

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Estacion_Trabajo_2] 
   @pUserName
GO

