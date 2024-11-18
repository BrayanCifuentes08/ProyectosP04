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
    public class Ctrl_PaExternalMarca : ControllerBase
    {
        private readonly string _connectionString;

        public Ctrl_PaExternalMarca(IConfiguration configuration)
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

                    var expectedColumnNames = new List<string> { "Marca", "Descripcion" };


                    var actualColumnNames = GetActualColumnNamesFromWorksheet(worksheet);

                    if (colCount != 2 || !expectedColumnNames.All(actualColumnNames.Contains))
                    {
                        return BadRequest("Las columnas de la hoja excel seleccionada no coinciden (Marca, Descripcion): " + string.Join(", ", actualColumnNames));
                    }

                    using (var connection = new SqlConnection(_connectionString))
                    {
                        connection.Open();

                        for (int row = 2; row <= rowCount; row++)
                        {
                            var firstCell = worksheet.Cells[row, 1].Value;
                            if (firstCell != null && !string.IsNullOrWhiteSpace(firstCell.ToString()))
                            {
                                var marca = Convert.ToInt32(worksheet.Cells[row, 1].Value);
                                var descripcion = worksheet.Cells[row, 2].Value.ToString();
                                
                                var fechaHora = DateTime.Now;

                                var parameters = new M_Marca
                                {
                                    pMarca = marca,
                                    pDescripcion = descripcion,
                                    pUserName = userName,
                                    pFechaHora = fechaHora,
                                    pMensaje = "",
                                    pResultado = true
                                };

                                connection.Execute("PaExternalMarca", parameters, commandType: System.Data.CommandType.StoredProcedure);
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
