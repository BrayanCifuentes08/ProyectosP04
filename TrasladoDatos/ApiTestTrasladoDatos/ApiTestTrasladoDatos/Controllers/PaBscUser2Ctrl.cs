using ApiTestTrasladoDatos.Connection;
using ApiTestTrasladoDatos.Model;
using Dapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ApiTestTrasladoDatos.Controllers
{
    [ApiController]
    public class PaBscUser2Ctrl : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public PaBscUser2Ctrl(IConfiguration configuration)
        {
            _configuration = configuration;
        }
 
        [HttpGet]
        [Route("api/[controller]")]
        public IActionResult login([FromQuery] int pOpcion, [FromQuery] string pUserName, [FromQuery] string pPass)
        {
            try
            {
                var connectionString = new Conexion().cadenaSQL();
                using (IDbConnection db = new SqlConnection(connectionString))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@pOpcion", pOpcion);
                    parameters.Add("@pUserName", pUserName);
                    parameters.Add("@pPass", pPass);

                    // Ejecutar el procedimiento almacenado y obtener los resultados
                    var resultados = db.Query<PaBscUser2M>("PA_bsc_User_2", parameters, commandType: CommandType.StoredProcedure);

                    var Resultado = resultados.Select(model => new
                    {
                        model.Continuar,
                        model.Mensaje,
                        model.UserName,
                    }).FirstOrDefault();

                    if (Resultado == null)
                    {
                        return Unauthorized(new { message = "Credenciales no válidas" });
                    }

                    if (Resultado.Continuar)
                    {
                        // Crear los claims para el token JWT
                        Claim[] claims = new[]
                        {
                            new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"]),
                            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                            new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                            new Claim("UserName", pUserName)
                        };

                        SymmetricSecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
                        SigningCredentials signing = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

                        JwtSecurityToken token = new JwtSecurityToken(
                            issuer: _configuration["Jwt:Issuer"],
                            audience: _configuration["Jwt:Audience"],
                            claims: claims,
                            expires: DateTime.UtcNow.AddDays(1),
                            signingCredentials: signing
                        );

                        string tokenString = new JwtSecurityTokenHandler().WriteToken(token);

                        // Devolver el token y los resultados
                        return Ok(new
                        {
                            Token = tokenString,
                            Resultado.Continuar,
                            Resultado.Mensaje,
                            Resultado.UserName
                        });
                    }
                    else
                    {
                        // Devolver solo el mensaje si no puede continuar
                        return Unauthorized(new
                        {
                            Resultado.Continuar,
                            Resultado.Mensaje,
                            Resultado.UserName
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno del servidor: {ex.Message}");
            }
        }
    }
}
