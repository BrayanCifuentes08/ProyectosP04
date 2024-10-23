namespace CuentasxCobrar.Model
{
    public class PaBscSerieDocumento1M
    {
        public int Tipo_Documento { get; set; }
        public int Serie_Documento { get; set; }
        public int Empresa { get; set; }
        public int Bodega { get; set; }
        public string Descripcion { get; set; }
        public decimal Serie_Ini { get; set; }
        public decimal Serie_Fin { get; set; }
        public bool Estado { get; set; }
        public string Campo01 { get; set; }
        public string Campo02 { get; set; }
        public string Campo03 { get; set; }
        public string Campo04 { get; set; }
        public string Campo05 { get; set; }
        public string Campo06 { get; set; }
        public string Campo07 { get; set; }
        public string Campo08 { get; set; }
        public string Campo09 { get; set; }
        public string Campo10 { get; set; }
        public int Documento_Disp { get; set; }
        public int Documento_Aviso { get; set; }
        public int Documento_Frecuencia { get; set; }
        public DateTime Fecha_Hora { get; set; }
        public int? Doc_Det { get; set; }
        public int? Limite_Impresion { get; set; }
        public string UserName { get; set; }
        public DateTime M_Fecha_Hora { get; set; } 
        public string M_UserName { get; set; }
        public int? Orden { get; set; }
        public int? Grupo { get; set; }
        public bool Opc_Venta { get; set; }
        public bool Bloquear_Imprimir { get; set; }
        public string Des_Tipo_Documento { get; set; }
    }
}
