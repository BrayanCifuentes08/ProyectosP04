using CuentasxCobrar.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CuentasxCobrar.Connection;
using Dapper;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Authorization;
using Newtonsoft.Json.Linq;

namespace CuentasxCobrar.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaTblDocumentoCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<PaTblDocumentoCtrl> _logger;

        public PaTblDocumentoCtrl(IConfiguration configuration , ILogger<PaTblDocumentoCtrl> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> crearDocumento([FromBody] PaTblDocumentoM model )
        {
            try
            {


                if (model.IsMobile == false) 
                {
                    var recaptchaValidationResult = await ValidateRecaptchaAsync(model.RecaptchaToken);
                    if (!recaptchaValidationResult)
                    {
                        return BadRequest("reCAPTCHA validation failed.");
                    }
                }


                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@TAccion", model.TAccion);
                    parameters.Add("@pDocumento", model.Documento);
                    parameters.Add("@pTipo_Documento", model.Tipo_Documento);
                    parameters.Add("@pSerie_Documento", model.Serie_Documento);
                    parameters.Add("@pEmpresa", model.Empresa);
                    parameters.Add("@pLocalizacion", model.Localizacion);
                    parameters.Add("@pEstacion_Trabajo", model.Estacion_Trabajo);
                    parameters.Add("@pFecha_Reg", model.Fecha_Reg);
                    parameters.Add("@pFecha_Hora", model.Fecha_Hora);
                    parameters.Add("@pUserName", model.UserName);
                    parameters.Add("@pM_Fecha_Hora", model.M_Fecha_Hora);
                    parameters.Add("@pM_UserName", model.M_UserName);
                    parameters.Add("@pCuenta_Correntista", model.Cuenta_Correntista);
                    parameters.Add("@pCuenta_Cta", model.Cuenta_Cta);
                    parameters.Add("@pDocumento_Nombre", model.Documento_Nombre);
                    parameters.Add("@pDocumento_NIT", model.Documento_NIT);
                    parameters.Add("@pDocumento_Direccion", model.Documento_Direccion);
                    parameters.Add("@pId_Reservacion", model.Id_Reservacion);
                    parameters.Add("@pBodega_Origen", model.Bodega_Origen);
                    parameters.Add("@pBodega_Destino", model.Bodega_Destino);
                    parameters.Add("@pObservacion_1", model.Observacion_1);
                    parameters.Add("@pFecha_Documento", model.Fecha_Documento);
                    parameters.Add("@pObservacion_2", model.Observacion_2);
                    parameters.Add("@pElemento_Asignado", model.Elemento_Asignado);
                    parameters.Add("@pEstado_Documento", model.Estado_Documento);
                    parameters.Add("@pImpresion_Doc", model.Impresion_Doc);
                    parameters.Add("@pReferencia", model.Referencia);
                    parameters.Add("@pDoc_Det", model.Doc_Det);
                    parameters.Add("@pFecha_Ini", model.Fecha_Ini);
                    parameters.Add("@pFecha_Fin", model.Fecha_Fin);
                    parameters.Add("@pFecha_Vencimiento", model.Fecha_Vencimiento);
                    parameters.Add("@pPer_O_Cargos", model.Per_O_Cargos);
                    parameters.Add("@pClasificacion", model.Clasificacion);
                    parameters.Add("@pCierre", model.Cierre);
                    parameters.Add("@pFecha_Documento_Aux", model.Fecha_Documento_Aux);
                    parameters.Add("@pRef_Serie", model.Ref_Serie);
                    parameters.Add("@pContabilizado", model.Contabilizado);
                    parameters.Add("@pTurno", model.Turno);
                    parameters.Add("@pObservacion_3", model.Observacion_3);
                    parameters.Add("@pCuenta_Correntista_Ref", model.Cuenta_Correntista_Ref);
                    parameters.Add("@pCambio", model.Cambio);
                    parameters.Add("@pCambio_Moneda", model.Cambio_Moneda);
                    parameters.Add("@pBloqueado", model.Bloqueado);
                    parameters.Add("@pBloquear_Venta", model.Bloquear_Venta);
                    parameters.Add("@pRazon", model.Razon);
                    parameters.Add("@pProceso", model.Proceso);
                    parameters.Add("@pConsecutivo_Interno", model.Consecutivo_Interno);
                    parameters.Add("@pCuenta_Correntista_Ref_2", model.Cuenta_Correntista_Ref_2);
                    parameters.Add("@pLocalizacion_Ref", model.Localizacion_Ref);
                    parameters.Add("@pTipo_Pago", model.Tipo_Pago);
                    parameters.Add("@pCampo_1", model.Campo_1);
                    parameters.Add("@pCampo_2", model.Campo_2);
                    parameters.Add("@pCampo_3", model.Campo_3);
                    parameters.Add("@pFecha_Hora_N", model.Fecha_Hora_N);
                    parameters.Add("@pFecha_Documento_N", model.Fecha_Documento_N);
                    parameters.Add("@pSeccion", model.Seccion);
                    parameters.Add("@pTipo_Actividad", model.Tipo_Actividad);
                    parameters.Add("@pCierre_Contable", model.Cierre_Contable);
                    parameters.Add("@pId_Unc", model.Id_Unc);
                    parameters.Add("@pIVA_Exento", model.IVA_Exento);
                    parameters.Add("@TOpcion", model.TOpcion);
                    parameters.Add("@pRef_Fecha_Documento", model.Ref_Fecha_Documento);
                    parameters.Add("@pRef_Fecha_Vencimiento", model.Ref_Fecha_Vencimiento);
                    parameters.Add("@pT_Tra_M", model.T_Tra_M);
                    parameters.Add("@pT_Tra_MM", model.T_Tra_MM);
                    parameters.Add("@pT_Car_Abo_M", model.T_Car_Abo_M);
                    parameters.Add("@pT_Car_Abo_MM", model.T_Car_Abo_MM);
                    parameters.Add("@pPropina_Monto", model.Propina_Monto);
                    parameters.Add("@pPropina_Monto_Moneda", model.Propina_Monto_Moneda);
                    parameters.Add("@pRef_Id_Documento", model.Ref_Id_Documento);
                    parameters.Add("@pT_Tra_M_NImp", model.T_Tra_M_NImp);
                    parameters.Add("@pT_Tra_MM_NImp", model.T_Tra_MM_NImp);
                    parameters.Add("@pT_Tra_M_Imp_IVA", model.T_Tra_M_Imp_IVA);
                    parameters.Add("@pT_Tra_MM_Imp_IVA", model.T_Tra_MM_Imp_IVA);
                    parameters.Add("@pT_Tra_M_Imp_ITU", model.T_Tra_M_Imp_ITU);
                    parameters.Add("@pT_Tra_MM_Imp_ITU", model.T_Tra_MM_Imp_ITU);
                    parameters.Add("@pT_Tra_M_Propina", model.T_Tra_M_Propina);
                    parameters.Add("@pT_Tra_MM_Propina", model.T_Tra_MM_Propina);
                    parameters.Add("@pT_Tra_M_Cargo", model.T_Tra_M_Cargo);
                    parameters.Add("@pT_Tra_MM_Cargo", model.T_Tra_MM_Cargo);
                    parameters.Add("@pT_Tra_M_Descuento", model.T_Tra_M_Descuento);
                    parameters.Add("@pT_Tra_MM_Descuento", model.T_Tra_MM_Descuento);
                    parameters.Add("@pT_Car_Abo_M_Por_Aplicar", model.T_Car_Abo_M_Por_Aplicar);
                    parameters.Add("@pT_Car_Abo_MM_Por_Aplicar", model.T_Car_Abo_MM_Por_Aplicar);
                    parameters.Add("@pT_Tra_M_Sub", model.T_Tra_M_Sub);
                    parameters.Add("@pT_Tra_MM_Sub", model.T_Tra_MM_Sub);
                    parameters.Add("@pVehiculo_Marca", model.Vehiculo_Marca);
                    parameters.Add("@pVehiculo_Modelo", model.Vehiculo_Modelo);
                    parameters.Add("@pVehiculo_Year", model.Vehiculo_Year);
                    parameters.Add("@pVehiculo_Color", model.Vehiculo_Color);
                    parameters.Add("@pSurvey_Record", model.Survey_Record);
                    parameters.Add("@pPeriodo", model.Periodo);
                    parameters.Add("@pAdults", model.Adults);
                    parameters.Add("@pChildrens", model.Childrens);
                    parameters.Add("@pId_Doc_Alt", model.Id_Doc_Alt);
                    parameters.Add("@pISR_Retener", model.ISR_Retener);
                    parameters.Add("@pFE_Cae", model.FE_Cae);
                    parameters.Add("@pFE_numeroDocumento", model.FE_numeroDocumento);
                    parameters.Add("@pFE_numeroDte", model.FE_numeroDte);
                    parameters.Add("@pGPS_Latitud", model.GPS_Latitud);
                    parameters.Add("@pGPS_Longitud", model.GPS_Longitud);
                    parameters.Add("@pConsecutivo_Interno_Ref", model.Consecutivo_Interno_Ref);
                    parameters.Add("@pFEL_UUID_Anulacion", model.FEL_UUID_Anulacion);
                    parameters.Add("@pFEL_Numero_Acceso", model.FEL_Numero_Acceso);
                    parameters.Add("@pFE_Fecha_Certificacion", model.FE_Fecha_Certificacion);
                    parameters.Add("@pId_Unc_Sync", model.Id_Unc_Sync);

                    var pIdDocumentoValue = db.Query<string>("SELECT dbo.fObt_Id_Documento(@pTipo_Documento, @pSerie_Documento, @pEmpresa)", new
                    {
                        pTipo_Documento = model.Tipo_Documento,
                        pSerie_Documento = model.Serie_Documento,
                        pEmpresa = model.Empresa
                    }).FirstOrDefault();
                    parameters.Add("@pId_Documento", pIdDocumentoValue);

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaTblDocumentoM>("PA_tbl_Documento", parameters, commandType: CommandType.StoredProcedure);

                    var resultado = resultados.Select(model => new
                    {
                        model.Documento,
                        model.Tipo_Documento,
                        model.Serie_Documento,
                        model.Empresa,
                        model.Localizacion,
                        model.Estacion_Trabajo,
                        model.Fecha_Reg,
                        model.Fecha_Hora,
                        model.UserName,
                        model.M_Fecha_Hora,
                        model.M_UserName,
                        model.Cuenta_Correntista,
                        model.Cuenta_Cta,
                        model.Id_Documento,
                        model.Documento_Nombre,
                        model.Documento_NIT,
                        model.Documento_Direccion,
                        model.Id_Reservacion,
                        model.Bodega_Origen,
                        model.Bodega_Destino,
                        model.Observacion_1,
                        model.Fecha_Documento,
                        model.Observacion_2,
                        model.Elemento_Asignado,
                        model.Estado_Documento,
                        model.Impresion_Doc,
                        model.Referencia,
                        model.Doc_Det,
                        model.Fecha_Ini,
                        model.Fecha_Fin,
                        model.Fecha_Vencimiento,
                        model.Per_O_Cargos,
                        model.Clasificacion,
                        model.Cierre,
                        model.Fecha_Documento_Aux,
                        model.Ref_Serie,
                        model.Contabilizado,
                        model.Turno,
                        model.Observacion_3,
                        model.Cuenta_Correntista_Ref,
                        model.Cambio,
                        model.Cambio_Moneda,
                        model.Bloqueado,
                        model.Bloquear_Venta,
                        model.Consecutivo_Interno,
                        model.Razon,
                        model.Proceso,
                        model.Cuenta_Correntista_Ref_2,
                        model.Localizacion_Ref,
                        model.Tipo_Pago,
                        model.Campo_1,
                        model.Campo_2,
                        model.Campo_3,
                        model.Fecha_Hora_N,
                        model.Fecha_Documento_N,
                        model.Seccion,
                        model.Tipo_Actividad,
                        model.Cierre_Contable,
                        model.Id_Unc,
                        model.IVA_Exento,
                        model.TOpcion,
                        model.Ref_Fecha_Documento,
                        model.Ref_Fecha_Vencimiento,
                        model.T_Tra_M,
                        model.T_Tra_MM,
                        model.T_Car_Abo_M,
                        model.T_Car_Abo_MM,
                        model.Propina_Monto,
                        model.Propina_Monto_Moneda,
                        model.Ref_Id_Documento,
                        model.T_Tra_M_NImp,
                        model.T_Tra_MM_NImp,
                        model.T_Tra_M_Imp_IVA,
                        model.T_Tra_MM_Imp_IVA,
                        model.T_Tra_M_Imp_ITU,
                        model.T_Tra_MM_Imp_ITU,
                        model.T_Tra_M_Propina,
                        model.T_Tra_MM_Propina,
                        model.T_Tra_M_Cargo,
                        model.T_Tra_MM_Cargo,
                        model.T_Tra_M_Descuento,
                        model.T_Tra_MM_Descuento,
                        model.T_Car_Abo_M_Por_Aplicar,
                        model.T_Car_Abo_MM_Por_Aplicar,
                        model.T_Tra_M_Sub,
                        model.T_Tra_MM_Sub,
                        model.Vehiculo_Marca,
                        model.Vehiculo_Modelo,
                        model.Vehiculo_Year,
                        model.Vehiculo_Color,
                        model.Survey_Record,
                        model.Periodo,
                        model.Adults,
                        model.Childrens,
                        model.Id_Doc_Alt,
                        model.ISR_Retener,
                        model.FE_Cae,
                        model.FE_numeroDocumento,
                        model.FE_numeroDte,
                        model.GPS_Latitud,
                        model.GPS_Longitud,
                        model.Consecutivo_Interno_Ref,
                        model.FEL_UUID_Anulacion,
                        model.FEL_Numero_Acceso,
                        model.FE_Fecha_Certificacion,
                        model.Id_Unc_Sync
                    });
                      
                    return Ok(resultado);
                   
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Exception: {ex.Message} - StackTrace: {ex.StackTrace} - InnerException: {ex.InnerException}");
                return StatusCode(StatusCodes.Status500InternalServerError, "Internal server error");
            }
        }

        private async Task<bool> ValidateRecaptchaAsync(string recaptchaToken)
        {
            if (string.IsNullOrWhiteSpace(recaptchaToken))
            {
                return false;
            }

            var secretKey = _configuration["Recaptcha:SecretKey"];
            var recaptchaUrl = $"https://www.google.com/recaptcha/api/siteverify?secret={secretKey}&response={recaptchaToken}";

            using (var client = new HttpClient())
            {
                var response = await client.GetStringAsync(recaptchaUrl);
                var json = JObject.Parse(response);
                return json["success"].Value<bool>();
            }
        }
    }
}
