using CuentasxCobrar.Connection;
using CuentasxCobrar.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
namespace CuentasxCobrar.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaCargoAbonoValidar1Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaCargoAbonoValidar1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]

        public IActionResult ValidarCargoAbono(
                [FromQuery] string pUserName,
                [FromQuery] int pCargo_Abono,
                [FromQuery] byte pEmpresa,
                [FromQuery] short pLocalizacion,
                [FromQuery] short pEstacion_Trabajo,
                [FromQuery] int pFecha_Reg,
                [FromQuery] int pD_Documento,
                [FromQuery] int pD_Tipo_Documento,
                [FromQuery] string pD_Serie_Documento,
                [FromQuery] int pD_Empresa ,
                [FromQuery] int pD_Localizacion,
                [FromQuery] int pD_Estacion_Trabajo ,
                [FromQuery] int pD_Fecha_Reg ,
                [FromQuery] int? pTipo_Cargo_Abono = null,
                [FromQuery] decimal pMonto = 0,
                [FromQuery] decimal pMonto_Moneda =  0,
                [FromQuery] decimal pTipo_Cambio = 0,
                [FromQuery] int? pMoneda = null,
                [FromQuery] string? pMensaje = null,
                [FromQuery] bool? pResultado = null,
                [FromQuery] string? pRef_Documento = null,
                [FromQuery] int? pCuenta_Bancaria = null,
                [FromQuery] string? pReferencia = null,
                [FromQuery] string? pAutorizacion = null,
                [FromQuery] bool pTrigger_Ins = true,
                [FromQuery] bool pVer_Tabla = true,
                [FromQuery] string? pRef_Fecha = null,
                [FromQuery] int? pResultado_Opcion = 1,
                [FromQuery] int? pBanco = 1
                )
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pCargo_Abono", pCargo_Abono);
                    parameters.Add("@pEmpresa", pEmpresa);
                    parameters.Add("@pLocalizacion", pLocalizacion);
                    parameters.Add("@pEstacion_Trabajo", pEstacion_Trabajo);
                    parameters.Add("@pFecha_Reg", pFecha_Reg);
                    parameters.Add("@pD_Documento", pD_Documento);
                    parameters.Add("@pD_Tipo_Documento", pD_Tipo_Documento);
                    parameters.Add("@pD_Serie_Documento", pD_Serie_Documento);
                    parameters.Add("@pD_Empresa", pD_Empresa);
                    parameters.Add("@pD_Localizacion", pD_Localizacion);
                    parameters.Add("@pD_Estacion_Trabajo", pD_Estacion_Trabajo);
                    parameters.Add("@pD_Fecha_Reg", pD_Fecha_Reg);
                    parameters.Add("@pTipo_Cargo_Abono", pTipo_Cargo_Abono);
                    parameters.Add("@pMonto", pMonto);
                    parameters.Add("@pMonto_Moneda", pMonto_Moneda);
                    parameters.Add("@pTipo_Cambio", pTipo_Cambio);
                    parameters.Add("@pMoneda", pMoneda);
                    parameters.Add("@pMensaje", pMensaje);
                    parameters.Add("@pResultado", pResultado);
                    parameters.Add("@pRef_Documento", pRef_Documento);
                    parameters.Add("@pCuenta_Bancaria", pCuenta_Bancaria);
                    parameters.Add("@pReferencia", pReferencia);
                    parameters.Add("@pAutorizacion", pAutorizacion);
                    parameters.Add("@pTrigger_Ins", pTrigger_Ins);
                    parameters.Add("@pVer_Tabla", pVer_Tabla);
                    parameters.Add("@pRef_Fecha", pRef_Fecha);
                    parameters.Add("@pResultado_Opcion", pResultado_Opcion);
                    parameters.Add("@pBanco", pBanco);

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaCargoAbonoValidar1M>("PA_Cargo_Abono_Validar_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Mensaje,
                        model.Resultado,
                    });

                    return Ok(Resultado);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }
    }
}
