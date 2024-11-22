using ApiTestTrasladoDatos.Models;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace ApiTestTrasladoDatos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class Ctrl_PaExternalTipoPrecio : ControllerBase
    {
        private readonly string _connectionString;

        public Ctrl_PaExternalTipoPrecio(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("ConnectionString");
        }

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

                    // Nombres esperados y mapeo
                    var expectedColumns = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
                    {
                        { "TipoPrecio", "TipoPrecio" },
                        { "Descripcion", "Descripcion" }
                    };

                    // Obtenemos el mapeo de las columnas reales en el Excel
                    var columnMapping = ObtenerMapeoDeColumnas(worksheet, expectedColumns);

                    if (columnMapping.Count != expectedColumns.Count)
                    {
                        return BadRequest("No se encontraron todas las columnas requeridas: " + string.Join(", ", expectedColumns.Keys));
                    }

                    using (var connection = new SqlConnection(_connectionString))
                    {
                        connection.Open();

                        for (int row = 2; row <= rowCount; row++)
                        {
                            var firstCell = worksheet.Cells[row, columnMapping["TipoPrecio"]].Value;
                            if (firstCell != null && !string.IsNullOrWhiteSpace(firstCell.ToString()))
                            {
                                var tipoPrecio = Convert.ToInt32(worksheet.Cells[row, columnMapping["TipoPrecio"]].Value);
                                var descripcion = worksheet.Cells[row, columnMapping["Descripcion"]].Value.ToString();
                                var fechaHora = DateTime.Now;

                                var parameters = new M_TipoPrecio
                                {
                                    pTipoPrecio = tipoPrecio,
                                    pDescripcion = descripcion,
                                    pUserName = userName,
                                    pFechaHora = fechaHora,
                                    pMensaje = "",
                                    pResultado = true
                                };

                                connection.Execute("PaExternalTipoPrecio", parameters, commandType: System.Data.CommandType.StoredProcedure);
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

        // Método para eliminar tildes (diacríticos)
        private string EliminarDiacriticos(string texto)
        {
            var textoNormalizado = texto.Normalize(NormalizationForm.FormD);
            var cadenaFinal = new StringBuilder();

            foreach (var caracter in textoNormalizado)
            {
                if (CharUnicodeInfo.GetUnicodeCategory(caracter) != UnicodeCategory.NonSpacingMark)
                {
                    cadenaFinal.Append(caracter);
                }
            }

            return cadenaFinal.ToString().Normalize(NormalizationForm.FormC);
        }

        // Método para obtener el mapeo de las columnas
        private Dictionary<string, int> ObtenerMapeoDeColumnas(ExcelWorksheet worksheet, Dictionary<string, string> expectedColumns)
        {
            var columnMapping = new Dictionary<string, int>();
            var firstRow = worksheet.Cells[1, 1, 1, worksheet.Dimension.Columns];

            foreach (var cell in firstRow)
            {
                var columnName = cell.Value?.ToString().Trim();
                if (columnName != null)
                {
                    columnName = EliminarDiacriticos(columnName);  // Eliminar tildes
                    foreach (var expectedColumn in expectedColumns)
                    {
                        if (string.Equals(columnName, expectedColumn.Key, StringComparison.OrdinalIgnoreCase))
                        {
                            columnMapping[expectedColumn.Value] = cell.Start.Column;
                        }
                    }
                }
            }

            return columnMapping;
        }

        public class ExcelData
        {
            public IFormFile ArchivoExcel { get; set; }
            public string NombreHojaExcel { get; set; }
        }
    }
}
