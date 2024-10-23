using CuentasxCobrar.Connection;
using CuentasxCobrar.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
namespace CuentasxCobrar.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaBscSerieDocumento1Ctrl : Controller
    {
        private readonly IConfiguration _configuration;

        public PaBscSerieDocumento1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]

        public IActionResult BusquedaSerie([FromQuery] int pTipo_Documento,
            [FromQuery] int pEmpresa,
            [FromQuery] int pEstacion_Trabajo,
            [FromQuery] string pUserName,
            [FromQuery] bool? pT_Filtro_6,
            [FromQuery] int pGrupo,
            [FromQuery] bool? pDocumento_Conv,
            [FromQuery] bool? pFE_Tipo,
            [FromQuery] int? pPOS_Tipo,
            [FromQuery] bool pVer_FE
            
            )
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pTipo_Documento", pTipo_Documento);
                    parameters.Add("@pEmpresa", pEmpresa);
                    parameters.Add("@pEstacion_Trabajo", pEstacion_Trabajo);
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pT_Filtro_6", pT_Filtro_6);
                    parameters.Add("@pGrupo", pGrupo);
                    parameters.Add("@pDocumento_Conv", pDocumento_Conv);
                    parameters.Add("@pFE_Tipo", pFE_Tipo);
                    parameters.Add("@pPOS_Tipo", pPOS_Tipo);
                    parameters.Add("@pVer_FE", pVer_FE);


                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscSerieDocumento1M>("PA_bsc_Serie_Documento_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Tipo_Documento,
                        model.Serie_Documento,
                        model.Empresa,
                        model.Bodega,
                        model.Descripcion,
                        model.Serie_Ini,
                        model.Serie_Fin,
                        model.Campo01,
                        model.Campo02,
                        model.Campo03,
                        model.Campo04,
                        model.Campo05,
                        model.Campo06,
                        model.Campo07,
                        model.Campo08,
                        model.Campo09,
                        model.Campo10,
                        model.Documento_Disp,
                        model.Documento_Aviso,
                        model.Documento_Frecuencia,
                        model.Fecha_Hora,
                        model.Doc_Det,
                        model.Limite_Impresion,
                        model.UserName,
                        model.M_Fecha_Hora,
                        model.M_UserName,
                        model.Orden,
                        model.Grupo,
                        model.Opc_Venta,
                        model.Bloquear_Imprimir,
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

