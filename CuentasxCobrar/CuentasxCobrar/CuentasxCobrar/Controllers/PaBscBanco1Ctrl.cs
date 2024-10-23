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
    public class PaBscBanco1Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscBanco1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]

        public IActionResult BusquedaBanco([FromQuery] string pUserName,
            [FromQuery] int pOpcion,
            [FromQuery] int pEmpresa
            )
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pEmpresa", pEmpresa);
                    parameters.Add("@pOpcion", pOpcion);


                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscBanco1M>("PA_bsc_Banco_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Banco,
                        model.Nombre,
                        model.Orden,
                      

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

