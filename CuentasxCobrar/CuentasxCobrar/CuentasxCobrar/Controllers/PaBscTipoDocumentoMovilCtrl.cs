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
    public class PaBscTipoDocumentoMovilCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscTipoDocumentoMovilCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]

        public IActionResult BusquedaTipoDocumento([FromQuery] string pUserName,
            [FromQuery] int pOpc_Cuenta_Corriente, 
            [FromQuery] int pCuenta_Corriente,
            [FromQuery] int pEmpresa,
            [FromQuery] int? pIngreso,
            [FromQuery] int? pCosto,
            [FromQuery] string? pMensaje,
            [FromQuery] int? pResultado
            )
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pOpc_Cuenta_Corriente", pOpc_Cuenta_Corriente);
                    parameters.Add("@pCuenta_Corriente", pCuenta_Corriente);
                    parameters.Add("@pEmpresa", pEmpresa);
                    parameters.Add("@pIngreso", pIngreso);
                    parameters.Add("@pCosto", pCosto);
                    parameters.Add("@pMensaje", pMensaje);
                    parameters.Add("@pResultado", pResultado);


                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscTipoDocumentoMovilM>("PA_bsc_Tipo_Documento_Movil", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Tipo_Documento,
                        model.Descripcion,
                        model.Cuenta_Corriente,
                        model.Cargo_Abono,
                        model.Contabilidad,
                        model.Documento_Bancario,
                        model.Origen_Cuenta_Corriente,
                        model.Opc_Verificar,
                        model.Opc_Cuenta_Corriente,
                        model.Orden_Cuenta_Corriente,
                   
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
