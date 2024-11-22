namespace ApiTestTrasladoDatos.Models
{
    public class PaTblDocumentoEstructuraM
    {
        public int Consecutivo_Interno { get; set; }
        public string Estructura { get; set; }
        public string UserName { get; set; }
        public DateTime Fecha_Hora { get; set; }
        public int Tipo_Estructura { get; set; }
        public int Estado { get; set; }
        public string? M_UserName { get; set; }
        public DateTime? M_Fecha_Hora { get; set; }
        public Guid Id_Unc {  get; set; }


    }
}
