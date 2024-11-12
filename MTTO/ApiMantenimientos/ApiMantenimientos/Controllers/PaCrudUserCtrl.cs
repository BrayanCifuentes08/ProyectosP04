using ApiMantenimientos.Connection;
using ApiMantenimientos.Models;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace ApiMantenimientos.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class PaCrudUserCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaCrudUserCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IActionResult crudUser(
            [FromQuery] int accion,
            [FromQuery] string? pCriterioBusqueda,
            [FromQuery] string? pUserName,
            [FromQuery] string? pName,
            [FromQuery] string? pCelular,
            [FromQuery] string? pEMail,
            [FromQuery] DateTime? pFecha_Hora
            )
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {

                    var parameters = new DynamicParameters();
                    parameters.Add("@accion", accion);
                    parameters.Add("@pCriterioBusqueda", pCriterioBusqueda);
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pName", pName);
                    parameters.Add("@pCelular", pCelular);
                    parameters.Add("@pEMail", pEMail);
                    parameters.Add("@pFecha_Hora", pFecha_Hora);

                    if (accion == 1) // SELECT
                    {
                        var resultados = db.Query<PaCrudUserM>("paCrudUser", parameters, commandType: CommandType.StoredProcedure);
                        var Resultado = resultados.Select(model => new
                        {
                            model.UserName,
                            model.Name,
                            model.Celular,
                            model.EMail,
                            model.Fecha_Hora,
                            model.Mensaje,
                            model.Resultado
                        });
                        return Ok(Resultado);
                    }
                    else if (accion == 2) // INSERT
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudUserM>("paCrudUser", parameters, commandType: CommandType.StoredProcedure);
                        if (resultado != null)
                        {
                            return Ok(new { resultado.Mensaje, resultado.Resultado });
                        }
                        return BadRequest("Error al insertar el registro.");
                    }
                    else if (accion == 3) // UPDATE
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudUserM>("paCrudUser", parameters, commandType: CommandType.StoredProcedure);
                        if (resultado != null)
                        {
                            return Ok(new { resultado.Mensaje, resultado.Resultado });
                        }
                        return BadRequest("Error al actualizar el registro.");
                    }
                    else if (accion == 4) // DELETE
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudUserM>("paCrudUser", parameters, commandType: CommandType.StoredProcedure);
                        if (resultado != null)
                        {
                            return Ok(new { resultado.Mensaje, resultado.Resultado });
                        }
                        return BadRequest("Error al eliminar el registro.");
                    }
                    else
                    {
                        return BadRequest("Acción no válida.");
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }
    }
}
