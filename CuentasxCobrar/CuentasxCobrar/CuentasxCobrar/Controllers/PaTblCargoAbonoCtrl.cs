using CuentasxCobrar.Connection;
using CuentasxCobrar.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Data.SqlClient;

namespace CuentasxCobrar.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaTblCargoAbonoCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaTblCargoAbonoCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> crearCargoAbono([FromBody] PaTblCargoAbonoM model)
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
                    parameters.Add("@pCargo_Abono", model.Cargo_Abono);
                    parameters.Add("@pEmpresa", model.Empresa);
                    parameters.Add("@pLocalizacion", model.Localizacion);
                    parameters.Add("@pEstacion_Trabajo", model.Estacion_Trabajo);
                    parameters.Add("@pFecha_Reg", model.Fecha_Reg);
                    parameters.Add("@pTipo_Cargo_Abono", model.Tipo_Cargo_Abono);
                    parameters.Add("@pEstado", model.Estado);
                    parameters.Add("@pFecha_Hora", model.Fecha_Hora);
                    parameters.Add("@pUserName", model.UserName);
                    parameters.Add("@pM_Fecha_Hora", model.M_Fecha_Hora);
                    parameters.Add("@pM_UserName", model.M_UserName);
                    parameters.Add("@pMonto", model.Monto);
                    parameters.Add("@pTipo_Cambio", model.Tipo_Cambio);
                    parameters.Add("@pMoneda", model.Moneda);
                    parameters.Add("@pMonto_Moneda", model.Monto_Moneda);
                    parameters.Add("@pReferencia", model.Referencia);
                    parameters.Add("@pAutorizacion", model.Autorizacion);
                    parameters.Add("@pBanco", model.Banco);
                    parameters.Add("@pObservacion_1", model.Observacion_1);
                    parameters.Add("@pRazon", model.Razon);
                    parameters.Add("@pD_Documento", model.D_Documento);
                    parameters.Add("@pD_Tipo_Documento", model.D_Tipo_Documento);
                    parameters.Add("@pD_Serie_Documento", model.D_Serie_Documento);
                    parameters.Add("@pD_Empresa", model.D_Empresa);
                    parameters.Add("@pD_Localizacion", model.D_Localizacion);
                    parameters.Add("@pD_Estacion_Trabajo", model.D_Estacion_Trabajo);
                    parameters.Add("@pD_Fecha_Reg", model.D_Fecha_Reg);
                    parameters.Add("@pPropina", model.Propina);
                    parameters.Add("@pPropina_Moneda", model.Propina_Moneda);
                    parameters.Add("@pMonto_O", model.Monto_O);
                    parameters.Add("@pMonto_O_Moneda", model.Monto_O_Moneda);
                    parameters.Add("@pF_Cuenta_Corriente_Padre", model.F_Cuenta_Corriente_Padre);
                    parameters.Add("@pF_Cobrar_Pagar_Padre", model.F_Cobrar_Pagar_Padre);
                    parameters.Add("@pF_Empresa_Padre", model.F_Empresa_Padre);
                    parameters.Add("@pF_Localizacion_Padre", model.F_Localizacion_Padre);
                    parameters.Add("@pF_Estacion_Trabajo_Padre", model.F_Estacion_Trabajo_Padre);
                    parameters.Add("@pF_Fecha_Reg_Padre", model.F_Fecha_Reg_Padre);
                    parameters.Add("@pRef_Documento", model.Ref_Documento);
                    parameters.Add("@pCuenta_Bancaria", model.Cuenta_Bancaria);
                    parameters.Add("@pPropina_Monto", model.Propina_Monto);
                    parameters.Add("@pPropina_Monto_Moneda", model.Propina_Monto_Moneda);
                    parameters.Add("@pCuenta_PIN", model.Cuenta_PIN);
                    parameters.Add("@TOpcion", model.TOpcion);
                    parameters.Add("@pFecha_Ref", model.Fecha_Ref);
                    parameters.Add("@pConsecutivo_Interno_Ref", model.Consecutivo_Interno_Ref);                 

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaTblCargoAbonoM>("PA_tbl_Cargo_Abono", parameters, commandType: CommandType.StoredProcedure);

                    var resultado = resultados.Select(model => new
                    {
                        model.Cargo_Abono,
                        model.Empresa,
                        model.Localizacion,
                        model.Estacion_Trabajo,
                        model.Fecha_Reg,
                        model.Tipo_Cargo_Abono,
                        model.Estado,
                        model.Fecha_Hora,
                        model.UserName,
                        model.M_Fecha_Hora,
                        model.M_UserName,
                        model.Monto,
                        model.Tipo_Cambio,
                        model.Moneda,
                        model.Monto_Moneda,
                        model.Referencia,
                        model.Autorizacion,
                        model.Banco,
                        model.Observacion_1,
                        model.Razon,
                        model.D_Documento,
                        model.D_Tipo_Documento,
                        model.D_Serie_Documento,
                        model.D_Empresa,
                        model.D_Localizacion,
                        model.D_Estacion_Trabajo,
                        model.D_Fecha_Reg,
                        model.Propina,
                        model.Propina_Moneda,
                        model.Monto_O,
                        model.Monto_O_Moneda,
                        model.F_Cuenta_Corriente_Padre,
                        model.F_Cobrar_Pagar_Padre,
                        model.F_Empresa_Padre,
                        model.F_Localizacion_Padre,
                        model.F_Estacion_Trabajo_Padre,
                        model.F_Fecha_Reg_Padre,
                        model.Ref_Documento,
                        model.Cuenta_Bancaria,
                        model.Propina_Monto,
                        model.Propina_Monto_Moneda,
                        model.Cuenta_PIN,
                        model.Fecha_Ref,
                        model.Consecutivo_Interno_Ref,
                      
                    });

                    return Ok(resultado);

                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
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
