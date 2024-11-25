using ApiTestTrasladoDatos.Models;
using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace ApiTestTrasladoDatos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaTblDocumentoEstructuraCtrl : ControllerBase
    {
        private readonly string _connectionString;

        public PaTblDocumentoEstructuraCtrl(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("ConnectionString");
        }

        [HttpPost]
        public IActionResult Post(
            [FromForm] ExcelData request,
            [FromForm] int TAccion,
            [FromForm] int TOpcion,
            [FromForm] string pUserName,
            [FromForm] int pConsecutivo_Interno,
            [FromForm] int pTipo_Estructura,
            [FromForm] int pEstado)
        {
            try
            {
                Console.WriteLine($"userName: {pUserName}, tAccion: {TAccion}, tOpcion: {TOpcion}, tipoEstructura: {pTipo_Estructura}, estado: {pEstado}");
                ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

                using (var package = new ExcelPackage(request.ArchivoExcel.OpenReadStream()))
                {
                    ExcelWorksheet worksheet = package.Workbook.Worksheets[request.NombreHojaExcel];
                    Console.WriteLine($"Nombre de la hoja: {request.NombreHojaExcel}");

                    if (worksheet == null)
                        return BadRequest(new { Message = "No se encontró la hoja especificada en el archivo Excel." });

                    if (worksheet.Dimension == null || worksheet.Dimension.Rows < 2 || worksheet.Dimension.Columns < 1)
                        return BadRequest(new { Message = "La hoja de Excel no contiene los datos esperados." });

                    Console.WriteLine($"Filas detectadas: {worksheet.Dimension.Rows}");
                    Console.WriteLine($"Columnas detectadas: {worksheet.Dimension.Columns}");

                    int rowCount = worksheet.Dimension.Rows;
                    int colCount = worksheet.Dimension.Columns;

                    // Procesar encabezados, ignorando los vacíos
                    var columnNames = worksheet.Cells[1, 1, 1, colCount]
                        .Select(cell => cell.Value?.ToString()?.Trim() ?? "")
                        .ToList();

                    // Verificar si hay encabezados vacíos, pero desde el último hasta el primero
                    for (int i = columnNames.Count - 1; i >= 0; i--)
                    {
                        if (string.IsNullOrWhiteSpace(columnNames[i]))
                        {
                            return BadRequest(new { Message = $"Se encontró un encabezado vacío en la columna {i + 1}. Todos los encabezados deben tener un valor." });
                        }
                    }

                    if (!columnNames.Any())
                        return BadRequest(new { Message = "La hoja no contiene encabezados válidos." });


                    // Determinar el tipo de cada columna (string, int o decimal)
                    var columnTypes = new Dictionary<string, Type>();

                    for (int col = 1; col <= colCount; col++)
                    {
                        bool allNumeric = true;
                        bool allIntegers = true;

                        for (int row = 2; row <= rowCount; row++)
                        {
                            // Validar que el índice de la celda está dentro del rango
                            if (row <= worksheet.Dimension.Rows && col <= worksheet.Dimension.Columns)
                            {
                                var cellValue = worksheet.Cells[row, col].Value?.ToString()?.Trim();

                                if (!string.IsNullOrWhiteSpace(cellValue))
                                {
                                    if (!decimal.TryParse(cellValue, out decimal decimalValue))
                                    {
                                        allNumeric = false;
                                        break;
                                    }

                                    if (decimalValue != Math.Floor(decimalValue))
                                    {
                                        allIntegers = false;
                                    }
                                }
                            }
                            else
                            {
                                return BadRequest(new { Message = $"Se ha intentado acceder a un índice fuera del rango de la hoja de Excel en la fila {row}, columna {col}." });
                            }
                        }

                        if (!allNumeric)
                        {
                            columnTypes[columnNames[col - 1]] = typeof(string);
                        }
                        else if (allIntegers)
                        {
                            columnTypes[columnNames[col - 1]] = typeof(int);
                        }
                        else
                        {
                            columnTypes[columnNames[col - 1]] = typeof(decimal);
                        }
                    }

                    var records = new List<Dictionary<string, object>>();

                    // Procesar registros, asignando tipos según el análisis previo
                    for (int row = 2; row <= rowCount; row++)
                    {
                        var record = new Dictionary<string, object>();

                        for (int col = 1; col <= columnNames.Count; col++)
                        {
                            var cellValue = worksheet.Cells[row, col].Value?.ToString()?.Trim();
                            var header = columnNames[col - 1];

                            if (string.IsNullOrWhiteSpace(cellValue))
                            {
                                record[header] = null;
                            }
                            else
                            {
                                Type columnType = columnTypes[header];

                                if (columnType == typeof(int))
                                {
                                    record[header] = int.Parse(cellValue);
                                }
                                else if (columnType == typeof(decimal))
                                {
                                    record[header] = decimal.Parse(cellValue);
                                }
                                else
                                {
                                    record[header] = cellValue; // Tratar como string
                                }
                            }
                        }

                        // Verificar si el primer campo (primer columna) es obligatorio
                        var firstFieldValue = record[columnNames.First()];
                        if (string.IsNullOrWhiteSpace(firstFieldValue?.ToString()))
                        {
                            return BadRequest(new { Message = $"El primer campo del registro en la fila {row} es obligatorio y está vacío." });
                        }

                        // Verificar si la fila tiene algún valor, ignorar si todos son null
                        if (record.Values.Any(value => value != null))
                        {
                            records.Add(record);
                        }
                    }

                    string estructuraJson = System.Text.Json.JsonSerializer.Serialize(records);
                    Console.WriteLine($"JSON generado: {estructuraJson}");

                    var parameters = new DynamicParameters();
                    parameters.Add("@TAccion", TAccion);
                    parameters.Add("@TOpcion", TOpcion);
                    parameters.Add("@pConsecutivo_Interno", pConsecutivo_Interno);
                    parameters.Add("@pEstructura", estructuraJson);
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pFecha_Hora", DateTime.Now);
                    parameters.Add("@pTipo_Estructura", pTipo_Estructura);
                    parameters.Add("@pEstado", pEstado);
                    parameters.Add("@pId_Unc", dbType: DbType.Guid);

                    using (var connection = new SqlConnection(_connectionString))
                    {
                        connection.Open();

                        // Ejecutar el procedimiento almacenado y obtener los resultados
                        var resultados = connection.Query<PaTblDocumentoEstructuraM>(
                            "PA_tbl_Documento_Estructura",
                            parameters,
                            commandType: CommandType.StoredProcedure);

                        // Transformar los resultados si es necesario
                        var resultadoFinal = resultados.Select(model => new
                        {
                            model.Consecutivo_Interno,
                            model.Estructura,
                            model.UserName,
                            model.Fecha_Hora,
                            model.Tipo_Estructura,
                            model.Estado
                        }).ToList();

                        // Devolver los datos como respuesta
                        return Ok(resultadoFinal);
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = $"Error: {ex.Message}. StackTrace: {ex.StackTrace}" });
            }
        }

        public class ExcelData
        {
            public IFormFile ArchivoExcel { get; set; }
            public string NombreHojaExcel { get; set; }
        }
    }
}
