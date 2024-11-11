using ApiMantenimientos.Connection;
using ApiMantenimientos.Models;
using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Authorization;

namespace ApiMantenimientos.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class PaCrudElementoAsignadoCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaCrudElementoAsignadoCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IActionResult crudElementoAsignado(
            [FromQuery] int accion,
            [FromQuery] string? pCriterioBusqueda,
            [FromQuery] int? pElementoAsignado,
            [FromQuery] string? pElementoId,
            [FromQuery] string? pUserName,
            [FromQuery] int? pEmpresa,
            [FromQuery] string? pDescripcion,
            [FromQuery] int? pEstado,
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
                    parameters.Add("@pElementoAsignado", pElementoAsignado);
                    parameters.Add("@pElementoId", pElementoId);
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pEmpresa", pEmpresa);
                    parameters.Add("@pDescripcion", pDescripcion);
                    parameters.Add("@pEstado", pEstado);
                    parameters.Add("@pFecha_Hora", pFecha_Hora);

                    if (accion == 1) // SELECT
                    {
                        var resultados = db.Query<PaCrudElementoAsignadoM>("paCrudElementoAsignado", parameters, commandType: CommandType.StoredProcedure);
                        var Resultado = resultados.Select(model => new
                        {
                            model.ElementoAsignado,
                            model.Descripcion,
                            model.ElementoId,
                            model.Empresa,
                            model.ElementoAsignadoPadre,
                            model.Estado,
                            model.Fecha_Hora,
                            model.UserName,
                            model.Mensaje,
                            model.Resultado
                        });
                        return Ok(Resultado);
                    }
                    else if (accion == 2) // INSERT
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudElementoAsignadoM>("paCrudElementoAsignado", parameters, commandType: CommandType.StoredProcedure);
                        if (resultado != null)
                        {
                            return Ok(new { resultado.Mensaje, resultado.Resultado });
                        }
                        return BadRequest("Error al insertar el registro.");
                    }
                    else if (accion == 3) // UPDATE
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudElementoAsignadoM>("paCrudElementoAsignado", parameters, commandType: CommandType.StoredProcedure);
                        if (resultado != null)
                        {
                            return Ok(new { resultado.Mensaje, resultado.Resultado });
                        }
                        return BadRequest("Error al actualizar el registro.");
                    }
                    else if (accion == 4) // DELETE
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudElementoAsignadoM>("paCrudElementoAsignado", parameters, commandType: CommandType.StoredProcedure);
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
