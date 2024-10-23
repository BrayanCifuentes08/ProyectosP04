	DECLARE @RC int
	DECLARE @pUserName varchar(max)                        = 'ds'
	DECLARE @pOpc_Cuenta_Corriente bit                = 1
	DECLARE @pCuenta_Corriente bit                        = 13
	DECLARE @pEmpresa tinyint                                = 1
	DECLARE @pIngreso bit                                        = 0
	DECLARE @pCosto bit                                                = 0
	DECLARE @pMensaje varchar(200)                        = ''
	DECLARE @pResultado bit                                        = 1

	-- TODO: Set parameter values here.

	EXECUTE @RC = [dbo].[PA_bsc_Tipo_Documento_Movil] 
	   @pUserName
	  ,@pOpc_Cuenta_Corriente
	  ,@pCuenta_Corriente
	  ,@pEmpresa
	  ,@pIngreso
	  ,@pCosto
	  ,@pMensaje OUTPUT
	  ,@pResultado OUTPUT
	GO