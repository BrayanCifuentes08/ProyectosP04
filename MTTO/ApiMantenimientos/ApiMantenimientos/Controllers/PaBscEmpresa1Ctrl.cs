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
    public class PaBscEmpresa1Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscEmpresa1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]
        [Route("api/[controller]")]
        public IActionResult obtenerEmpresas([FromQuery] string pUserName)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName);

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscEmpresa1M>("PA_bsc_Empresa_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Empresa,
                        model.Empresa_Nombre,
                        model.Razon_Social,
                        model.Empresa_NIT,
                        model.Empresa_Direccion,
                        model.Numero_Patronal,
                        model.Estado,
                        model.Campo_1,
                        model.Campo_2,
                        model.Campo_3,
                        model.Campo_4,
                        model.Campo_5,
                        model.Campo_6,
                        model.Campo_7,
                        model.Campo_8
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

