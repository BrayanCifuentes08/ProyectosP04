namespace ApiMantenimientos.Models
{
    public class PaCrudElementoAsignadoM
    {
        public int? Elemento_Asignado { get; set; }
        public string? Descripcion { get; set; }
        public string? Elemento_Id { get; set; }
        public int? Empresa { get; set; }
        public int? Elemento_Asignado_Padre { get; set; }
        public int? Estado { get; set; }
        public DateTime? Fecha_Hora { get; set; }
        public string? UserName { get; set; }
        public string? Mensaje { get; set; }
        public bool Resultado { get; set; }
    }
}
