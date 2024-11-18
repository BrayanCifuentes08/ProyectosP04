using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Text.Json;

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

        public class AppSettings
        {
            public ConnectionStrings ConnectionStrings { get; set; }    

        }

        public class ConnectionStrings
        {
            public string ConnectionString { get; set; }
        }

        public class ConnectionSettings
        {
            public string ServerName { get; set; }
            public string DatabaseName { get; set; }
            public string UserId { get; set; }
            public string Password { get; set; }
        }

        [HttpPost()]
        public IActionResult UpdateConnectionString([FromBody] ConnectionSettings settings)
        {
            try
            {
                // Nueva cadena de conexión
                string newConnectionString = $"Server={settings.ServerName}; Database={settings.DatabaseName}; User Id={settings.UserId}; Password={settings.Password};";
                // Prueba la conexión para verificar errores específicos
                using (var connection = new SqlConnection(newConnectionString))
                {
                    connection.Open();
                    //  actualiza la configuración en appsettings.json
                    var appSettingsPath = Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json");
                    var appSettingsJson = System.IO.File.ReadAllText(appSettingsPath);
                    var appSettings = JsonSerializer.Deserialize<AppSettings>(appSettingsJson);
                    appSettings.ConnectionStrings.ConnectionString = newConnectionString;
                    var updatedJson = JsonSerializer.Serialize(appSettings, new JsonSerializerOptions { WriteIndented = true });
                    System.IO.File.WriteAllText(appSettingsPath, updatedJson);
                    return Ok(new { message = "Conexión realizada correctamente." });
                }
            }
            catch (SqlException ex)
            {
                // Error específico de SQL Server
                return BadRequest(new { message = $"Error al conectar con la base de datos: {ex.Message}" });
            }
            catch (Exception ex)
            {
                // Otros errores generales
                return BadRequest(new { message = $"Error inesperado al actualizar la cadena de conexión: {ex.Message}" });
            }
        }
    }
}
