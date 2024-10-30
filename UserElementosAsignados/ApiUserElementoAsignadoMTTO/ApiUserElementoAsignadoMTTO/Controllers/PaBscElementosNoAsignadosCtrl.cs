using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ApiUserElementoAsignadoMTTO.Connection;
using System.Data;
using System.Data.SqlClient;
using ApiUserElementoAsignadoMTTO.Model;

namespace ApiUserElementoAsignadoMTTO.Controllers
{
    [ApiController]
    public class PaBscElementosNoAsignadosCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscElementosNoAsignadosCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]
        [Route("api/[controller]")]
        public IActionResult obtenerElementosNoAsignados()
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                   

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscElementosNoAsignadosM>("Pa_bsc_Elementos_No_Asignados", commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Elemento_Asignado,
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

