using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using CuentasxCobrar.Model;
using CuentasxCobrar.Connection;
using Dapper;
using Microsoft.AspNetCore.Authorization;

public class PaBscCuentaCorriente1Ctrl : ControllerBase
{
    private readonly IConfiguration _configuration;

    public PaBscCuentaCorriente1Ctrl(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    [Authorize]
    [HttpGet]
    [Route("api/[controller]")]
    public IActionResult GetCuentaCorriente(PaBscCuentaCorriente1M model)
    {
        try
        {
            var connectionString = new Conexion().cadenaSQL(); // Obtener cadena de conexión
            using (IDbConnection db = new SqlConnection(connectionString))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@pCuenta_Correntista", model.pCuenta_Correntista);
                parameters.Add("@pCuenta_Cta", model.pCuenta_Cta);
                parameters.Add("@pEmpresa", model.pEmpresa);
                parameters.Add("@pCobrar_Pagar", model.pCobrar_Pagar);
                parameters.Add("@pSaldo", model.pSaldo);
                parameters.Add("@pReferencia", model.pReferencia);
                parameters.Add("@pFil_Documento_Relacion", model.pFil_Documento_Relacion);
                parameters.Add("@pUserName", model.pUserName);
                parameters.Add("@pTotal_Monto", model.pTotal_Monto, DbType.Decimal, ParameterDirection.Output);
                parameters.Add("@pTotal_Aplicado", model.pTotal_Aplicado, DbType.Decimal, ParameterDirection.Output);
                parameters.Add("@pTotal_Saldo", model.pTotal_Saldo, DbType.Decimal, ParameterDirection.Output);
                parameters.Add("@pSel_Monto", model.pSel_Monto, DbType.Decimal, ParameterDirection.Output);
                parameters.Add("@pSel_Aplicado", model.pSel_Aplicado, DbType.Decimal, ParameterDirection.Output);
                parameters.Add("@pSel_Saldo", model.pSel_Saldo, DbType.Decimal, ParameterDirection.Output);
                parameters.Add("@pOpcion_Orden", model.pOpcion_Orden);
                parameters.Add("@pSQL_str", model.pSQL_str);
                parameters.Add("@pFecha_Documento", model.pFecha_Documento);

                // Ejecutar el procedimiento almacenado y obtener los resultados
                var results = db.Query("PA_bsc_Cuenta_Corriente_1", parameters, commandType: CommandType.StoredProcedure);

                return Ok(results);
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Error interno del servidor: {ex.Message}");
        }
    }
}
