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
    public class PaDocumentoValidar1Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaDocumentoValidar1Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [Authorize]
        [HttpGet]

        public IActionResult ValidarDocumento(
                [FromQuery] string pUserName ,                        
                [FromQuery] int pDocumento ,
                [FromQuery] byte pTipo_Documento ,                           
                [FromQuery] string pSerie_Documento ,                  
                [FromQuery] byte pEmpresa ,
                [FromQuery] short pLocalizacion ,
                [FromQuery] short pEstacion_Trabajo ,
                [FromQuery] int pFecha_Reg ,
                [FromQuery] DateTime? pFecha_Documento = null,               
                [FromQuery] int pCuenta_Correntista = 1,                  
                [FromQuery] string pCuenta_Cta  = "",            
                [FromQuery] bool pBloqueado = false,
                [FromQuery] byte pEstado_Objeto = 1,
                [FromQuery] string pMensaje = " ",                           
                [FromQuery] bool pResultado = true,
                [FromQuery] int? pElemento_Asignado = null,
                [FromQuery] int? pReferencia = null,
                [FromQuery] string pId_Documento = "",                  
                [FromQuery] string? pRef_Serie = null,
                [FromQuery] DateTime? pFecha_Vencimiento = null,
                [FromQuery] int? pCuenta_Correntista_Ref = null,
                [FromQuery] byte pAccion = 0,
                [FromQuery] bool? pIVA_Exento = null,
                [FromQuery] string? pRef_Id_Documento = null,
                [FromQuery] byte? pResultado_Opcion = null,
                [FromQuery] short? pBodega_Origen = null,
                [FromQuery] short? pBodega_Destino = null,
                [FromQuery] string? pObservacion_1 = null,
                [FromQuery] string? pObservacion_2 = null,
                [FromQuery] string? pObservacion_3 = null
                )
         {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pUserName", pUserName );                 
                    parameters.Add("@pDocumento", pDocumento);
                    parameters.Add("@pTipo_Documento", pTipo_Documento);
                    parameters.Add("@pSerie_Documento", pSerie_Documento );       
                    parameters.Add("@pEmpresa", pEmpresa);
                    parameters.Add("@pLocalizacion", pLocalizacion);
                    parameters.Add("@pEstacion_Trabajo", pEstacion_Trabajo);
                    parameters.Add("@pFecha_Reg", pFecha_Reg);
                    parameters.Add("@pFecha_Documento", pFecha_Documento ); 
                    parameters.Add("@pCuenta_Correntista", pCuenta_Correntista);
                    parameters.Add("@pCuenta_Cta", pCuenta_Cta );                 
                    parameters.Add("@pBloqueado", pBloqueado);
                    parameters.Add("@pEstado_Objeto", pEstado_Objeto);
                    parameters.Add("@pMensaje", pMensaje );                      
                    parameters.Add("@pResultado", pResultado);
                    parameters.Add("@pElemento_Asignado", pElemento_Asignado);         
                    parameters.Add("@pReferencia", pReferencia);
                    parameters.Add("@pId_Documento", pId_Documento);         
                    parameters.Add("@pRef_Serie", pRef_Serie);                           
                    parameters.Add("@pFecha_Vencimiento", pFecha_Vencimiento);           
                    parameters.Add("@pCuenta_Correntista_Ref", pCuenta_Correntista_Ref); 
                    parameters.Add("@pAccion", pAccion);
                    parameters.Add("@pIVA_Exento", pIVA_Exento);                        
                    parameters.Add("@pRef_Id_Documento", pRef_Id_Documento);             
                    parameters.Add("@pResultado_Opcion", pResultado_Opcion);          
                    parameters.Add("@pBodega_Origen", pBodega_Origen);                   
                    parameters.Add("@pBodega_Destino", pBodega_Destino);                 
                    parameters.Add("@pObservacion_1", pObservacion_1);                   
                    parameters.Add("@pObservacion_2", pObservacion_2);                  
                    parameters.Add("@pObservacion_3", pObservacion_3);                 

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaDocumentoValidar1M>("PA_Documento_Validar_1", parameters, commandType: CommandType.StoredProcedure);


                    var Resultado = resultados.Select(model => new
                    {
                        model.Mensaje,
                        model.Resultado,
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

