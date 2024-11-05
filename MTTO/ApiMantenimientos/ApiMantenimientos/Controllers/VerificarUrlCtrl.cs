using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ApiMantenimientos.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VerificarUrlCtrl : ControllerBase
    {
        [HttpGet("estado")]
        public IActionResult VerificarEstado()
        {
            // Este método devuelve un estado 200 OK si la API está en funcionamiento
            return Ok("La URL es válida");
        }
    }
}
