
--Antes validar con PA_Documento_Validar_1
--crea encabezado de documento
USE [test_cuenta_corriente]
GO

DECLARE @RC int
DECLARE @TAccion tinyint                                                                = 1      -- Inserta documento
DECLARE @pDocumento int                                                                 = 0 
DECLARE @pTipo_Documento tinyint                                                        = 5      --dato ingresado por el usuario
DECLARE @pSerie_Documento varchar(5)                                                    = 2      --dato ingresado por el usuario
DECLARE @pEmpresa tinyint                                                               = 1      --login
DECLARE @pLocalizacion smallint                                                         = 1 
DECLARE @pEstacion_Trabajo smallint                                                     = 1      --login
DECLARE @pFecha_Reg int                                                                 = 0
DECLARE @pFecha_Hora datetime                                                           = getdate()
DECLARE @pUserName varchar(30)                                                          = 'ds'   --login
DECLARE @pM_Fecha_Hora datetime                                                         = null
DECLARE @pM_UserName varchar(30)                                                        = null
DECLARE @pCuenta_Correntista int                                                        = 12     --de cliente
DECLARE @pCuenta_Cta varchar(20)                                                        = '1'    --de cliente
DECLARE @pId_Documento varchar(20)                                                      = dbo.fObt_Id_Documento(@pTipo_Documento,@pSerie_Documento,@pEmpresa)
DECLARE @pDocumento_Nombre varchar(200)                                                 = 'nombre cliente'
DECLARE @pDocumento_NIT varchar(30)                                                     = 'nit cliente'
DECLARE @pDocumento_Direccion varchar(200)                                              = 'direccion cliente'
DECLARE @pId_Reservacion varchar(20)                                                    = null
DECLARE @pBodega_Origen smallint                                                        = null
DECLARE @pBodega_Destino smallint                                                       = null
DECLARE @pObservacion_1 varchar(max)                                                    = 'observacion ingresada por el usuario'
DECLARE @pFecha_Documento datetime                                                      = getdate()--Fecha ingresada por el cliente
DECLARE @pObservacion_2 varchar(8000)                                                   = null
DECLARE @pElemento_Asignado smallint                                                    = null
DECLARE @pEstado_Documento tinyint                                                      = 1        --1= activo, 3=anulado
DECLARE @pImpresion_Doc tinyint                                                         = null
DECLARE @pReferencia int                                                                = null
DECLARE @pDoc_Det varchar(200)                                                          = null
DECLARE @pFecha_Ini datetime                                                            = null
DECLARE @pFecha_Fin datetime                                                            = null
DECLARE @pFecha_Vencimiento datetime                                                    = null
DECLARE @pPer_O_Cargos bit                                                              = null
DECLARE @pClasificacion smallint                                                        = null
DECLARE @pCierre tinyint                                                                = null
DECLARE @pFecha_Documento_Aux datetime                                                  = null
DECLARE @pRef_Serie varchar(30)                                                         = null
DECLARE @pContabilizado bit                                                             = null
DECLARE @pTurno tinyint                                                                 = null
DECLARE @pObservacion_3 varchar(200)                                                    = null
DECLARE @pCuenta_Correntista_Ref int                                                    = null
DECLARE @pCambio numeric(18,2)                                                          = null
DECLARE @pCambio_Moneda numeric(18,2)                                                   = null
DECLARE @pBloqueado bit                                                                 = null
DECLARE @pBloquear_Venta bit                                                            = null
DECLARE @pRazon tinyint                                                                 = null
DECLARE @pProceso int                                                                   = null
DECLARE @pConsecutivo_Interno int                                                       = null
DECLARE @pCuenta_Correntista_Ref_2 int                                                  = null
DECLARE @pLocalizacion_Ref smallint                                                     = null
DECLARE @pTipo_Pago tinyint                                                             = null
DECLARE @pCampo_1 numeric(18,2)                                                         = null
DECLARE @pCampo_2 numeric(18,2)                                                         = null
DECLARE @pCampo_3 numeric(18,2)                                                         = null
DECLARE @pFecha_Hora_N int                                                              = null
DECLARE @pFecha_Documento_N int                                                         = null
DECLARE @pSeccion smallint                                                              = null
DECLARE @pTipo_Actividad smallint                                                       = null
DECLARE @pCierre_Contable tinyint                                                       = null
DECLARE @pId_Unc uniqueidentifier                                                       = null
DECLARE @pIVA_Exento bit                                                                = null
DECLARE @TOpcion tinyint                                                                = 1
DECLARE @pRef_Fecha_Documento datetime                                                  = null
DECLARE @pRef_Fecha_Vencimiento datetime                                                = null
DECLARE @pT_Tra_M numeric(18,2)                                                         = null
DECLARE @pT_Tra_MM numeric(18,2)                                                        = null
DECLARE @pT_Car_Abo_M numeric(18,2)                                                     = null
DECLARE @pT_Car_Abo_MM numeric(18,2)                                                    = null
DECLARE @pPropina_Monto numeric(18,2)                                                   = null
DECLARE @pPropina_Monto_Moneda numeric(18,2)                                            = null
DECLARE @pRef_Id_Documento varchar(20)                                                  = null
DECLARE @pT_Tra_M_NImp numeric(18,2)                                                    = null
DECLARE @pT_Tra_MM_NImp numeric(18,2)                                                   = null
DECLARE @pT_Tra_M_Imp_IVA numeric(18,2)                                                 = null
DECLARE @pT_Tra_MM_Imp_IVA numeric(18,2)                                                = null
DECLARE @pT_Tra_M_Imp_ITU numeric(18,2)                                                 = null
DECLARE @pT_Tra_MM_Imp_ITU numeric(18,2)                                                = null
DECLARE @pT_Tra_M_Propina numeric(18,2)                                                 = null
DECLARE @pT_Tra_MM_Propina numeric(18,2)                                                = null
DECLARE @pT_Tra_M_Cargo numeric(18,2)                                                   = null
DECLARE @pT_Tra_MM_Cargo numeric(18,2)                                                  = null
DECLARE @pT_Tra_M_Descuento numeric(18,2)                                               = null
DECLARE @pT_Tra_MM_Descuento numeric(18,2)                                              = null
DECLARE @pT_Car_Abo_M_Por_Aplicar numeric(18,2)                                         = null
DECLARE @pT_Car_Abo_MM_Por_Aplicar numeric(18,2)                                        = null
DECLARE @pT_Tra_M_Sub numeric(18,2)                                                     = null
DECLARE @pT_Tra_MM_Sub numeric(18,2)                                                    = null
DECLARE @pVehiculo_Marca smallint                                                       = null
DECLARE @pVehiculo_Modelo smallint                                                      = null
DECLARE @pVehiculo_Year smallint                                                        = null
DECLARE @pVehiculo_Color smallint                                                       = null
DECLARE @pSurvey_Record int                                                             = null
DECLARE @pPeriodo smallint                                                              = null
DECLARE @pAdults tinyint                                                                = null
DECLARE @pChildrens tinyint                                                             = null
DECLARE @pId_Doc_Alt int                                                                = null
DECLARE @pISR_Retener bit                                                               = null
DECLARE @pFE_Cae varchar(200)                                                           = null
DECLARE @pFE_numeroDocumento varchar(200)                                               = null
DECLARE @pFE_numeroDte varchar(200)                                                     = null
DECLARE @pGPS_Latitud varchar(200)                                                      = null
DECLARE @pGPS_Longitud varchar(200)                                                     = null
DECLARE @pConsecutivo_Interno_Ref bigint                                                = null
DECLARE @pFEL_UUID_Anulacion varchar(400)                                               = null
DECLARE @pFEL_Numero_Acceso int                                                         = null
DECLARE @pFE_Fecha_Certificacion varchar(50)                                            = null
DECLARE @pId_Unc_Sync uniqueidentifier                                                  = null

-- TODO: Set parameter values here.

EXECUTE @RC = [dbo].[PA_tbl_Documento] 
   @TAccion
  ,@pDocumento OUTPUT
  ,@pTipo_Documento
  ,@pSerie_Documento
  ,@pEmpresa
  ,@pLocalizacion
  ,@pEstacion_Trabajo
  ,@pFecha_Reg OUTPUT
  ,@pFecha_Hora
  ,@pUserName
  ,@pM_Fecha_Hora
  ,@pM_UserName
  ,@pCuenta_Correntista
  ,@pCuenta_Cta
  ,@pId_Documento
  ,@pDocumento_Nombre
  ,@pDocumento_NIT
  ,@pDocumento_Direccion
  ,@pId_Reservacion
  ,@pBodega_Origen
  ,@pBodega_Destino
  ,@pObservacion_1
  ,@pFecha_Documento
  ,@pObservacion_2
  ,@pElemento_Asignado
  ,@pEstado_Documento
  ,@pImpresion_Doc
  ,@pReferencia
  ,@pDoc_Det
  ,@pFecha_Ini
  ,@pFecha_Fin
  ,@pFecha_Vencimiento
  ,@pPer_O_Cargos
  ,@pClasificacion
  ,@pCierre
  ,@pFecha_Documento_Aux
  ,@pRef_Serie
  ,@pContabilizado
  ,@pTurno
  ,@pObservacion_3
  ,@pCuenta_Correntista_Ref
  ,@pCambio
  ,@pCambio_Moneda
  ,@pBloqueado
  ,@pBloquear_Venta
  ,@pRazon
  ,@pProceso
  ,@pConsecutivo_Interno OUTPUT
  ,@pCuenta_Correntista_Ref_2
  ,@pLocalizacion_Ref
  ,@pTipo_Pago
  ,@pCampo_1
  ,@pCampo_2
  ,@pCampo_3
  ,@pFecha_Hora_N
  ,@pFecha_Documento_N
  ,@pSeccion
  ,@pTipo_Actividad
  ,@pCierre_Contable
  ,@pId_Unc OUTPUT
  ,@pIVA_Exento
  ,@TOpcion
  ,@pRef_Fecha_Documento
  ,@pRef_Fecha_Vencimiento
  ,@pT_Tra_M
  ,@pT_Tra_MM
  ,@pT_Car_Abo_M
  ,@pT_Car_Abo_MM
  ,@pPropina_Monto
  ,@pPropina_Monto_Moneda
  ,@pRef_Id_Documento
  ,@pT_Tra_M_NImp
  ,@pT_Tra_MM_NImp
  ,@pT_Tra_M_Imp_IVA
  ,@pT_Tra_MM_Imp_IVA
  ,@pT_Tra_M_Imp_ITU
  ,@pT_Tra_MM_Imp_ITU
  ,@pT_Tra_M_Propina
  ,@pT_Tra_MM_Propina
  ,@pT_Tra_M_Cargo
  ,@pT_Tra_MM_Cargo
  ,@pT_Tra_M_Descuento
  ,@pT_Tra_MM_Descuento
  ,@pT_Car_Abo_M_Por_Aplicar
  ,@pT_Car_Abo_MM_Por_Aplicar
  ,@pT_Tra_M_Sub
  ,@pT_Tra_MM_Sub
  ,@pVehiculo_Marca
  ,@pVehiculo_Modelo
  ,@pVehiculo_Year
  ,@pVehiculo_Color
  ,@pSurvey_Record
  ,@pPeriodo
  ,@pAdults
  ,@pChildrens
  ,@pId_Doc_Alt
  ,@pISR_Retener
  ,@pFE_Cae
  ,@pFE_numeroDocumento
  ,@pFE_numeroDte
  ,@pGPS_Latitud
  ,@pGPS_Longitud
  ,@pConsecutivo_Interno_Ref
  ,@pFEL_UUID_Anulacion
  ,@pFEL_Numero_Acceso
  ,@pFE_Fecha_Certificacion
  ,@pId_Unc_Sync
GO


