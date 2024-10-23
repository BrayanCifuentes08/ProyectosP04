use test_cuenta_corriente

GO

DECLARE @RC int
DECLARE @TAccion tinyint                        = 1
DECLARE @TOpcion tinyint                        = 1
DECLARE @pFiltro_1 varchar(30)                = 'ds' --UserName

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Application_1] 
   @TAccion
  ,@TOpcion
  ,@pFiltro_1
GO

