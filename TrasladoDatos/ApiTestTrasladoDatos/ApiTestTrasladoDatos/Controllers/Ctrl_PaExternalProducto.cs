using ApiTestTrasladoDatos.Models;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using OfficeOpenXml;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Linq;

namespace ApiTestTrasladoDatos.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class Ctrl_PaExternalProducto : ControllerBase
    {
        private readonly string _connectionString;

        public Ctrl_PaExternalProducto(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("ConnectionString");
        }
        [Authorize]
        [HttpPost]
        public IActionResult Post([FromForm] ExcelData request, [FromForm] string userName)
        {
            try
            {
                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
                using (var package = new ExcelPackage(request.ArchivoExcel.OpenReadStream()))
                {
                    ExcelWorksheet worksheet = package.Workbook.Worksheets[request.NombreHojaExcel];

                    var rowCount = worksheet.Dimension.Rows;
                    var colCount = worksheet.Dimension.Columns;

                    var expectedColumnNames = new List<string> { "Producto", "Descripcion", "ProductoId", "UnidadMedida", "DesUM", "Bodega", "NomBodega", "TipoPrecio", "DesTipoPrecio", "Monto", "Familia", "DesFamilia", "Marca", "DesMarca" };


                    var actualColumnNames = GetActualColumnNamesFromWorksheet(worksheet);

                    if (colCount != 14 || !expectedColumnNames.All(actualColumnNames.Contains))
                    {
                        return BadRequest("Las columnas de la hoja excel seleccionada no coinciden (Producto, Descripcion, ProductoId, UnidadMedida, DesUm, Bodega, NomBodega, TipoPrecio, DesTipoPrecio, Monto, Familia, DesFamilia, Marca, DesMarca): " + string.Join(", ", actualColumnNames));
                    }

                    using (var connection = new SqlConnection(_connectionString))
                    {
                        connection.Open();

                        for (int row = 2; row <= rowCount; row++)
                        {
                            var firstCell = worksheet.Cells[row, 1].Value;
                            if (firstCell != null && !string.IsNullOrWhiteSpace(firstCell.ToString()))
                            {
                                var producto = Convert.ToInt32(worksheet.Cells[row, 1].Value);
                                var descripcion = worksheet.Cells[row, 2].Value.ToString();
                                var productoId = worksheet.Cells[row, 3].Value.ToString();
                                var unidadMedida = Convert.ToInt32(worksheet.Cells[row, 4].Value);
                                var desUM = worksheet.Cells[row, 5].Value.ToString();
                                var bodega = Convert.ToInt32(worksheet.Cells[row, 6].Value);
                                var nomBodega = worksheet.Cells[row, 7].Value.ToString();
                                var tipoPrecio = Convert.ToInt32(worksheet.Cells[row, 8].Value);
                                var desTipoPrecio = worksheet.Cells[row, 9].Value.ToString();
                                var monto = Convert.ToDecimal(worksheet.Cells[row, 10].Value);
                                var familia = Convert.ToInt32(worksheet.Cells[row, 11].Value);
                                var desFamilia = worksheet.Cells[row, 12].Value.ToString();
                                var marca = Convert.ToInt32(worksheet.Cells[row, 13].Value);
                                var desMarca = worksheet.Cells[row, 14].Value.ToString();
                                var fechaHora = DateTime.Now;

                                var parameters = new M_Producto
                                {
                                    pProducto = producto,
                                    pDescripcion = descripcion,
                                    pProductoId = productoId,
                                    pUnidadMedida = unidadMedida,
                                    pDesUM = desUM,
                                    pBodega = bodega,
                                    pNomBodega = nomBodega,
                                    pTipoPrecio = tipoPrecio,
                                    pDesTipoPrecio = desTipoPrecio,
                                    pMonto = monto,
                                    pFamilia = familia,
                                    pDesFamilia = desFamilia,
                                    pMarca = marca,
                                    pDesMarca = desMarca,
                                    pUserName = userName,
                                    pFechaHora = fechaHora,
                                    pMensaje = "",
                                    pResultado = true
                                };

                                connection.Execute("PaExternalProducto", parameters, commandType: System.Data.CommandType.StoredProcedure);
                            }
                        }

                        connection.Close();
                    }
                }

                return Ok("Procedimiento almacenado ejecutado correctamente");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al ejecutar procedimiento almacenado: {ex.Message}");
            }
        }

        private List<string> GetActualColumnNamesFromWorksheet(ExcelWorksheet worksheet)
        {
            var firstRow = worksheet.Cells[1, 1, 1, worksheet.Dimension.Columns];
            return firstRow.Select(cell => cell.Value?.ToString().Trim() ?? "").ToList();
        }

        public class ExcelData
        {
            public IFormFile ArchivoExcel { get; set; }
            public string NombreHojaExcel { get; set; }
        }
    }
}
