using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data;
using System.Data.SqlClient;
using CuentasxCobrar.Model;
using CuentasxCobrar.Connection;
using Dapper;
using Microsoft.AspNetCore.Authorization;

public class PaBscCuentaCorrentistaMovilCtrl : ControllerBase
{
    private readonly IConfiguration _configuration;

    public PaBscCuentaCorrentistaMovilCtrl(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    [Authorize]
    [HttpGet]
    [Route("api/[controller]")]
    public IActionResult BusquedaCliente([FromQuery] string pUserName, [FromQuery] string pCriterio_Busqueda, [FromQuery] int pEmpresa)
    {
        try
        {
            var connectionString = new Conexion().cadenaSQL(); 
            using (IDbConnection db = new SqlConnection(connectionString))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@pUserName", pUserName);
                parameters.Add("@pCriterio_Busqueda", pCriterio_Busqueda);
                parameters.Add("@pEmpresa", pEmpresa);

                // Ejecutar el procedimiento almacenado y obtener los resultados
                var resultados = db.Query<PaBscCuentaCorrentistaMovilM>("PA_bsc_Cuenta_Correntista_Movil", parameters, commandType: CommandType.StoredProcedure);

                
                var Resultado = resultados.Select(model => new
                {
                    model.Cuenta_Correntista,
                    model.Cuenta_Cta,
                    model.Factura_Nombre,
                    model.Factura_Nit,
                    model.Factura_Direccion,
                    model.CC_Direccion,
                    model.Des_Cuenta_Cta,
                    model.Direccion_1_Cuenta_Cta,
                    model.Email,
                    model.Telefono,
                    model.Celular,
                    model.Limite_Credito,
                    model.Permitir_CxC,
                    model.Grupo_Cuenta,
                    model.Des_Grupo_Cuenta
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