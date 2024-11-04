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
    public class PaBscUserDisplay2Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscUserDisplay2Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]
        [Route("api/[controller]")]
        public IActionResult obtenerAccesos([FromQuery] string UserName, [FromQuery] int Application)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@UserName", UserName);
                    parameters.Add("@Application", Application);
        

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscUserDisplay2M>("PA_bsc_User_Display_2", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.User_Display,
                        model.User_Display_Father,
                        model.UserName,
                        model.Name,
                        model.Active,
                        model.Visible,
                        model.Rol,
                        model.Display,
                        model.Application,
                        model.Param,
                        model.Orden,
                        model.Consecutivo_Interno,
                        model.Display_URL,
                        model.Display_Menu,
                        model.Display_URL_Alter,
                        model.Language_ID,
                        model.Tipo_Documento,
                        model.Des_Tipo_Documento,
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
