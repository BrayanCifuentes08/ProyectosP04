using CuentasxCobrar.Connection;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace CuentasxCobrar.Model
{
    public class M_Login
    {
        public string nombre { get; set; } = string.Empty;
        public string contraseña { get; set; } = string.Empty;
    }
}
