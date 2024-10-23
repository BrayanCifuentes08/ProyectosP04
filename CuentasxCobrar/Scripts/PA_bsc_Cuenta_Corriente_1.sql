DECLARE @RC int
DECLARE @pCuenta_Correntista int                                        = 12               
DECLARE @pCuenta_Cta varchar(20)                                        = 1
DECLARE @pEmpresa tinyint                                                        = 1
DECLARE @pCobrar_Pagar tinyint                                                = 1
DECLARE @pSaldo bit                                                                        = 1
DECLARE @pReferencia int                                                        = null
DECLARE @pFil_Documento_Relacion varchar(100)                = null
DECLARE @pUserName varchar(30)                                                = 'ds'
DECLARE @pTotal_Monto numeric(18,2)                                        = null
DECLARE @pTotal_Aplicado numeric(18,2)                                = null
DECLARE @pTotal_Saldo numeric(18,2)                                        = null
DECLARE @pSel_Monto numeric(18,2)                                        = null
DECLARE @pSel_Aplicado numeric(18,2)                                = null
DECLARE @pSel_Saldo numeric(18,2)                                        = null
DECLARE @pOpcion_Orden tinyint                                                = 1
DECLARE @pSQL_str varchar(max)                                                = null
DECLARE @pFecha_Documento bit                                                = null

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_bsc_Cuenta_Corriente_1] 
   @pCuenta_Correntista
  ,@pCuenta_Cta
  ,@pEmpresa
  ,@pCobrar_Pagar
  ,@pSaldo
  ,@pReferencia
  ,@pFil_Documento_Relacion
  ,@pUserName
  ,@pTotal_Monto OUTPUT
  ,@pTotal_Aplicado OUTPUT
  ,@pTotal_Saldo OUTPUT
  ,@pSel_Monto OUTPUT
  ,@pSel_Aplicado OUTPUT
  ,@pSel_Saldo OUTPUT
  ,@pOpcion_Orden
  ,@pSQL_str
  ,@pFecha_Documento
GO