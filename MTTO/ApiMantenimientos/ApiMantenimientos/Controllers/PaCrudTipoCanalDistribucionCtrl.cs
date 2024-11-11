﻿using ApiMantenimientos.Connection;
using ApiMantenimientos.Model;
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
    public class PaCrudTipoCanalDistribucionCtrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaCrudTipoCanalDistribucionCtrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IActionResult crudTipoCanalDistribucion(
            [FromQuery] int accion, 
            [FromQuery] string? pCriterioBusqueda,
            [FromQuery] int? pTipoCanalDistribucion,
            [FromQuery] string? pDescripcion,
            [FromQuery] int? pEstado,
            [FromQuery] DateTime? pFecha_Hora,
            [FromQuery] string? pUserName)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@accion", accion);
                    parameters.Add("@pCriterioBusqueda", pCriterioBusqueda);
                    parameters.Add("@pTipoCanalDistribucion", pTipoCanalDistribucion);
                    parameters.Add("@pDescripcion", pDescripcion);
                    parameters.Add("@pEstado", pEstado);
                    parameters.Add("@pFecha_Hora", pFecha_Hora);
                    parameters.Add("@pUserName", pUserName);

                    if (accion == 1) // SELECT
                    {
                        var resultados = db.Query<PaCrudCanalDistribucionM>("Pa_bsc_TipoCanalDistribucion", parameters, commandType: CommandType.StoredProcedure);
                        var Resultado = resultados.Select(model => new
                        {
                            model.TipoCanalDistribucion,
                            model.Descripcion,
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
                        var resultado = db.QueryFirstOrDefault<PaCrudCanalDistribucionM>("Pa_bsc_TipoCanalDistribucion", parameters, commandType: CommandType.StoredProcedure);
                        if (resultado != null)
                        {
                            return Ok(new { resultado.Mensaje, resultado.Resultado });
                        }
                        return BadRequest("Error al insertar el registro.");
                    }
                    else if (accion == 3) // UPDATE
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudCanalDistribucionM>("Pa_bsc_TipoCanalDistribucion", parameters, commandType: CommandType.StoredProcedure);
                        if (resultado != null)
                        {
                            return Ok(new { resultado.Mensaje, resultado.Resultado });
                        }
                        return BadRequest("Error al actualizar el registro.");
                    }
                    else if (accion == 4) // DELETE
                    {
                        var resultado = db.QueryFirstOrDefault<PaCrudCanalDistribucionM>("Pa_bsc_TipoCanalDistribucion", parameters, commandType: CommandType.StoredProcedure);
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