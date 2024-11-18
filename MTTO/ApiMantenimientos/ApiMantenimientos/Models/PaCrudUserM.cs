namespace ApiMantenimientos.Models
{
    public class PaCrudUserM
    {
        public string? UserName { get; set; }
        public string? Name { get; set; }
        public string? Celular { get; set; }
        public string? EMail { get; set; }
        public byte[] Pass_Key { get; set; }
        public bool Disable {  get; set; }
        public int? Empresa { get; set; }
        public int? Estacion_Trabajo { get; set; }
        public int? Application { get; set; }
        public int? Language_ID { get; set; }
        public DateTime? Fecha_Hora { get; set; }
        public string? Mensaje { get; set; }
        public bool Resultado { get; set; }
    }
}
