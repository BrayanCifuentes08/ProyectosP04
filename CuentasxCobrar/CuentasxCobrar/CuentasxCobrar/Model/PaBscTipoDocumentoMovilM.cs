namespace CuentasxCobrar.Model
{
    public class PaBscTipoDocumentoMovilM
    {
        public int Tipo_Documento { get; set; }
        public string Descripcion { get; set; }
        public int Cuenta_Corriente { get; set; }
        public int Cargo_Abono { get; set; }
        public int Contabilidad { get; set; }
        public int Documento_Bancario { get; set; }
        public int Origen_Cuenta_Corriente { get; set; }
        public bool Opc_Verificar { get; set; } 
        public bool Opc_Cuenta_Corriente { get; set; }
        public int Orden_Cuenta_Corriente { get; set; }
       
   
    }
}
