USE test_cuenta_corriente
GO

DECLARE @RC int
DECLARE @pOpcion tinyint                = 1
DECLARE @pUserName varchar(30)          = 'AUDITOR01'
DECLARE @pPass varchar(100)             = '123'

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_User_2] 
   @pOpcion
  ,@pUserName
  ,@pPass
GO
