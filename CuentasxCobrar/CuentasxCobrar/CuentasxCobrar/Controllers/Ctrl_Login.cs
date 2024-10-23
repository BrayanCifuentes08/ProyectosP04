using System;
using System.Data;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using CuentasxCobrar.Connection;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using CuentasxCobrar.Model;

namespace CuentasxCobrar.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class Ctrl_Login : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public Ctrl_Login(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("login")]
        public IActionResult Login([FromBody] M_Login loginModel)
        {
            try
            {
                using (SqlConnection sql = new SqlConnection(new Conexion().cadenaSQL()))
                {
                    sql.Open();
                    using (SqlCommand command = new SqlCommand("pa_proLoginUser", sql)) //Procedimiento almacenado
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Utilizar hash para almacenar y comparar contraseñas


                        command.Parameters.AddWithValue("@nombre", loginModel.nombre); //variables del model asignados para parámetros de sql
                        command.Parameters.AddWithValue("@contraseña", loginModel.contraseña); //variables del model  asignados para parámetros de sql

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string resultMessage = reader["Resultado"].ToString();

                                if (resultMessage == "Acceso permitido.")
                                {
                                    // Configuración de claims y generar token JWT
                                    Claim[] claims = new[]
                                    {
                                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["JwToken:Subject"]),
                                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                                        new Claim("@nombre", loginModel.nombre)
                                    };

                                    SymmetricSecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JwToken:Key"]));
                                    SigningCredentials signing = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                                    JwtSecurityToken token = new JwtSecurityToken(
                                        _configuration["JwToken:Issuer"],
                                        _configuration["JwToken:Audience"],
                                        claims,
                                        expires: DateTime.UtcNow.AddMinutes(30), // Ajustar el tiempo de expiración
                                        signingCredentials: signing);

                                    return Ok(new JwtSecurityTokenHandler().WriteToken(token));
                                }
                                else
                                {
                                    return Unauthorized(new { message = resultMessage });
                                }
                            }
                            else
                            {
                                return Unauthorized(new { message = "El usuario no existe" });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error en la autenticación: {ex.GetType().Name} - {ex.Message}");
            }
        }


    }
}
