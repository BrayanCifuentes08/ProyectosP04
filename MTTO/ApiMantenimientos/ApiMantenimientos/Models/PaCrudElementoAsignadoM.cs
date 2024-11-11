namespace ApiMantenimientos.Models
{
    public class PaCrudElementoAsignadoM
    {
        public int? ElementoAsignado { get; set; }
        public string? Descripcion { get; set; }
        public string? ElementoId { get; set; }
        public int? Empresa { get; set; }
        public int? ElementoAsignadoPadre { get; set; }
        public int? Estado { get; set; }
        public DateTime? Fecha_Hora { get; set; }
        public string? UserName { get; set; }
        public string? Mensaje { get; set; }
        public bool Resultado { get; set; }
    }
}
