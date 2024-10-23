using ApiUserElementoAsignadoMTTO.Connection;
using ApiUserElementoAsignadoMTTO.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace ApiUserElementoAsignadoMTTO.Controllers
{
    [ApiController]
    public class PaBscUserElementoAsignadoCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscUserElementoAsignadoCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        //[Authorize]
        [HttpGet]
        [Route("api/[controller]")]
        public IActionResult obtenerElementosAsignados(
            [FromQuery] string pUserName
            )
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName);
                   

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscUserElementoAsignadoM>("Pa_bsc_User_Elemento_Asignado", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.UserName,
                        model.Elemento_Asignado,
                        model.Descripcion,
                        model.Fecha_Hora,

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
