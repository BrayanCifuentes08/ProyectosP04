use test_cuenta_corriente

GO

DECLARE @RC int
DECLARE @UserName varchar(30)        = 'ds'
DECLARE @Application tinyint        = 10

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_User_Display_2] 
   @UserName
  ,@Application
GO

