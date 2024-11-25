using ApiTestTrasladoDatos.Connection;
using ApiTestTrasladoDatos.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace ApiTestTrasladoDatos.Controllers
{

    [ApiController]
    public class PaBscEstacionTrabajo2Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscEstacionTrabajo2Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]
        [Route("api/[controller]")]
        public IActionResult obtenerEstacionTrabajo([FromQuery] string pUserName)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName);

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscEstacionTrabajo2M>("PA_bsc_Estacion_Trabajo_2", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Estacion_Trabajo,
                        model.Nombre,
                        model.Descripcion,
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
