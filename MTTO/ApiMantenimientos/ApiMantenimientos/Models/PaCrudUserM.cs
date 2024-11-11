namespace ApiMantenimientos.Models
{
    public class PaCrudUserM
    {
        public int? UserName { get; set; }
        public string? Name { get; set; }
        public int? Estado { get; set; }
        public DateTime? Fecha_Hora { get; set; }
        public string? Mensaje { get; set; }
        public bool Resultado { get; set; }
    }
}
