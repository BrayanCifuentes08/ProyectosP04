using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using OfficeOpenXml;
using System;
using System.Collections.Generic;

namespace ApiSistemaCompra.Controllers
{
  
    [Route("api/[controller]")]
    [ApiController]
    public class Ctrl_ObtenerHojasExcel : ControllerBase
    {
        // POST: api/Excel/ObtenerHojas
        [HttpPost()]
        public IActionResult Post([FromForm] Microsoft.AspNetCore.Http.IFormFile archivoExcel)
        {
            try
            {
                using (var package = new ExcelPackage(archivoExcel.OpenReadStream()))
                {
                    List<string> nombresHojas = new List<string>();

                    foreach (var sheet in package.Workbook.Worksheets)
                    {
                        nombresHojas.Add(sheet.Name);
                    }

                    return Ok(nombresHojas);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al leer el archivo Excel: {ex.Message}");
            }
        }
    }
}
