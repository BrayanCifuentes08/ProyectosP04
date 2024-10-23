using CuentasxCobrar.Connection;
using CuentasxCobrar.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace CuentasxCobrar.Controllers
{

    public class PaBscCuentaBancaria1Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscCuentaBancaria1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]
        [Route("api/[controller]")]
 

        public IActionResult BusquedaCuentaBancaria(
            [FromQuery] string pUserName, 
            [FromQuery] string pBanco, 
            [FromQuery] int pEmpresa)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pBanco", pBanco);
                    parameters.Add("@pEmpresa", pEmpresa);

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscCuentaBancaria1M>("PA_bsc_Cuenta_Bancaria_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Cuenta_Bancaria,
                        model.Descripcion,
                        model.Banco,
                        model.Id_Cuenta_Bancaria,
                        model.Ban_Ini,
                        model.Ban_Ini_Mes,
                        model.Cuenta,
                        model.Num_Doc,
                        model.Saldo,
                        model.Estado,
                        model.Lugar,
                        model.Ban_Ini_Dia,
                        model.Fecha_Hora,
                        model.UserName,
                        model.M_Fecha_Hora,
                        model.M_UserName,
                        model.Orden,
                        model.Serie_Ini,
                        model.Serie_Fin,
                        model.Moneda,
                        model.Cuenta_M
                       
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
