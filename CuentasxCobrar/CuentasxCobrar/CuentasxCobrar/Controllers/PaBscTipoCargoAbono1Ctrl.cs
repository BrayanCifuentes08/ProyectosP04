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
    [Route("api/[controller]")]
    [ApiController]
    public class PaBscTipoCargoAbono1Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscTipoCargoAbono1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]

        public IActionResult BusquedaTipoPago([FromQuery] int pTipo_Documento,
            [FromQuery] string pSerie_Documento,
            [FromQuery] int pEmpresa
            

            )
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pTipo_Documento", pTipo_Documento);
                    parameters.Add("@pSerie_Documento", pSerie_Documento);
                    parameters.Add("@pEmpresa", pEmpresa);
                 

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscTipoCargoAbono1M>("PA_bsc_Tipo_Cargo_Abono_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Tipo_Cargo_Abono,
                        model.Descripcion,
                        model.Monto,
                        model.Referencia,
                        model.Autorizacion,
                        model.Calcular_Monto,
                        model.Cuenta_Corriente,
                        model.Reservacion,
                        model.Factura,
                        model.Efectivo,
                        model.Banco,
                        model.Fecha_Vencimiento,
                        model.Comision_Porcentaje,
                        model.Comision_Monto,
                        model.Cuenta,
                        model.Contabilizar,
                        model.Val_Limite_Credito,
                        model.Msg_Limite_Credito,
                        model.Cuenta_Correntista,
                        model.Cuenta_Cta,
                        model.Bloquear_Documento,
                        model.URL,
                        model.Req_Cuenta_Bancaria,
                        model.Req_Ref_Documento,
                        model.Req_Fecha
                      
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

