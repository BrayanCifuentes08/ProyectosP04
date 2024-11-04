using ApiMantenimientos.Connection;
using ApiMantenimientos.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace ApiMantenimientos.Controllers
{

    [ApiController]
    public class PaBscApplication1Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscApplication1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]
        [Route("api/[controller]")]
        public IActionResult obtenerAplicaciones([FromQuery] int TAccion, [FromQuery] int TOpcion, [FromQuery] string pFiltro_1)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@TAccion", TAccion);
                    parameters.Add("@TOpcion", TOpcion);
                    parameters.Add("@pFiltro_1", pFiltro_1);

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscApplication1M>("PA_bsc_Application_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Application,
                        model.Application_Father,
                        model.Description,
                        model.Observacion_1,
                      
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
