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
    [Route("api/[controller]")]
    [ApiController]
    public class PaDeleteUserElementoAsignadoCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaDeleteUserElementoAsignadoCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpDelete]
        public async Task<IActionResult> eliminarUserElementoAsignado([FromBody] PaDeleteUserElementoAsignadoM model)
        {
            try
            {



                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", model.UserName);
                    parameters.Add("@pElemento_Asignado", model.Elemento_Asignado);


                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaDeleteUserElementoAsignadoM>("Pa_delete_User_Elemento_Asignado", parameters, commandType: CommandType.StoredProcedure);

                    var resultado = resultados.Select(model => new
                    {
                        model.resultado,
                        model.mensaje,

                    });

                    return Ok(resultado);

                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }
    }
}
