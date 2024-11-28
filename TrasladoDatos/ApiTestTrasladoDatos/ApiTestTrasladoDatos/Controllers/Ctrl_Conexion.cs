using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace ApiTestTrasladoDatos.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class Ctrl_Conexion : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public Ctrl_Conexion(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public class ConnectionSettings
        {
            public string ServerName { get; set; }
            public string DatabaseName { get; set; }
            public string UserId { get; set; }
            public string Password { get; set; }
        }
        [Authorize]
        [HttpPost()]
        public IActionResult UpdateConnectionString([FromBody] ConnectionSettings settings)
        {
            try
            {
                // Nueva cadena de conexión
                string newConnectionString = $"Server={settings.ServerName}; Database={settings.DatabaseName}; User Id={settings.UserId}; Password={settings.Password};";

                // Prueba la conexión antes de guardar
                using (var connection = new SqlConnection(newConnectionString))
                {
                    connection.Open();
                }

                // Ruta del archivo appsettings.json
                var appSettingsPath = Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json");
                if (!System.IO.File.Exists(appSettingsPath))
                {
                    return BadRequest(new { message = "El archivo appsettings.json no existe." });
                }

                // Leer y deserializar el contenido actual
                var appSettingsJson = System.IO.File.ReadAllText(appSettingsPath);
                var jsonObject = JsonNode.Parse(appSettingsJson);

                // Cambia el tipo JsonNode a JsonObject explícitamente
                if (jsonObject["ConnectionStrings"] is JsonObject connectionStrings)
                {
                    // Actualiza el campo ConnectionString
                    connectionStrings["ConnectionString"] = newConnectionString;

                    // Escribe los cambios en el archivo
                    System.IO.File.WriteAllText(appSettingsPath, jsonObject.ToJsonString(new JsonSerializerOptions { WriteIndented = true }));

                    return Ok(new { message = "Conexión actualizada correctamente." });
                }


                return BadRequest(new { message = "No se encontró la sección 'ConnectionStrings' en el archivo de configuración." });
            }
            catch (SqlException ex)
            {
                // Error específico de SQL Server
                return BadRequest(new { message = $"Error al conectar con la base de datos: {ex.Message}" });
            }
            catch (Exception ex)
            {
                // Otros errores generales
                return BadRequest(new { message = $"Error inesperado: {ex.Message}" });
            }
        }
    }
}
