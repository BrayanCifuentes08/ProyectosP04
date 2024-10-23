using CuentasxCobrar.Connection;
using CuentasxCobrar.Model;
using System.Data.SqlClient;
using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Reflection;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Authorization;
using Newtonsoft.Json.Linq;

namespace CuentasxCobrar.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaDocumentoAplicar31Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaDocumentoAplicar31Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> crearDocumentoAplicar([FromBody] DocumentoAplicarParametros model)
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
                    parameters.Add("@pOpcion", model.pOpcion);
                    parameters.Add("@pUserName", model.pUserName);
                    parameters.Add("@pTipo_Cambio", model.pTipo_Cambio);
                    parameters.Add("@pMoneda", model.pMoneda);
                    parameters.Add("@pMensaje", model.pMensaje);
                    parameters.Add("@pResultado", model.pResultado);
                    parameters.Add("@pDoc_CC_Documento", model.pDoc_CC_Documento);
                    parameters.Add("@pDoc_CC_Tipo_Documento", model.pDoc_CC_Tipo_Documento);
                    parameters.Add("@pDoc_CC_Serie_Documento", model.pDoc_CC_Serie_Documento);
                    parameters.Add("@pDoc_CC_Empresa", model.pDoc_CC_Empresa);
                    parameters.Add("@pDoc_CC_Localizacion", model.pDoc_CC_Localizacion);
                    parameters.Add("@pDoc_CC_Estacion_Trabajo",model.pDoc_CC_Estacion_Trabajo);
                    parameters.Add("@pDoc_CC_Fecha_Reg", model.pDoc_CC_Fecha_Reg);
                    parameters.Add("@pDoc_CC_Cuenta_Correntista", model.pDoc_CC_Cuenta_Correntista);
                    parameters.Add("@pDoc_CC_Cuenta_Cta", model.pDoc_CC_Cuenta_Cta);
                    parameters.Add("@pDoc_CC_Fecha_Documento", model.pDoc_CC_Fecha_Documento);
                    parameters.Add("@pCA_Monto_Total", model.pCA_Monto_Total);
                    parameters.Add("@pTCA_Monto", model.pTCA_Monto);
                    parameters.Add("@pEstructura", JsonConvert.SerializeObject(model.pEstructura));

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaDocumentoAplicar31M>("PA_Documento_Aplicar_3_1", parameters, commandType: CommandType.StoredProcedure);

                    var resultado = resultados.Select(model => new
                    {   
                        model.ID,
                        model.Cuenta_Corriente,
                        model.Cobrar_Pagar,
                        model.Empresa,
                        model.Localizacion,
                        model.Estacion_Trabajo,
                        model.Fecha_Reg,
                        model.Monto,
                        model.Cuenta_Correntista,
                        model.Cuenta_Cta,
                      
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
public class DocumentoAplicarParametros
{
    public int pOpcion { get; set; }
    public string pUserName { get; set; }
    public decimal pTipo_Cambio { get; set; }
    public int pMoneda { get; set; }
    public string pMensaje { get; set; }
    public bool pResultado { get; set; }
    public int pDoc_CC_Documento { get; set; }
    public int pDoc_CC_Tipo_Documento { get; set; }
    public string pDoc_CC_Serie_Documento { get; set; }
    public int pDoc_CC_Empresa { get; set; }
    public int pDoc_CC_Localizacion { get; set; }
    public int pDoc_CC_Estacion_Trabajo { get; set; }
    public int pDoc_CC_Fecha_Reg { get; set; } 
    public int pDoc_CC_Cuenta_Correntista { get; set; }
    public string pDoc_CC_Cuenta_Cta { get; set; }
    public DateTime pDoc_CC_Fecha_Documento { get; set; }
    public decimal pCA_Monto_Total { get; set; }
    public bool pTCA_Monto { get; set; }
    public Estructura pEstructura { get; set; }
    public String RecaptchaToken { get; set; }
    public bool IsMobile { get; set; }
}

public class CuentaCorriente
{
    public int CC_Cuenta_Corriente { get; set; }
    public int CC_Cobrar_Pagar { get; set; }
    public int CC_Empresa { get; set; }
    public int CC_Localizacion { get; set; }
    public int CC_Estacion_Trabajo { get; set; }
    public int CC_Fecha_Reg { get; set; }
    public int CC_D_Documento { get; set; }
    public int CC_D_Tipo_Documento { get; set; }
    public string CC_D_Serie_Documento { get; set; }
    public int CC_D_Empresa { get; set; }
    public int CC_D_Localizacion { get; set; }
    public int CC_D_Estacion_Trabajo { get; set; }
    public int CC_D_Fecha_Reg { get; set; }
    public decimal CC_Monto { get; set; }
    public decimal CC_Monto_M { get; set; }
    public int CC_Cuenta_Correntista { get; set; }
    public string CC_Cuenta_Cta { get; set; }
}

public class Estructura
{
    public List<CuentaCorriente> CuentaCorriente { get; set; }
}

