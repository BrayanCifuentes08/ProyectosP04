namespace CuentasxCobrar.Model
{
    public class PaBscCuentaCorrentistaMovilM
    {

        public int Cuenta_Correntista { get; set; }
        public string Cuenta_Cta { get; set; } = string.Empty;
        public string Factura_Nombre { get; set; } = string.Empty;
        public string Factura_Nit { get; set; } = string.Empty;
        public string Factura_Direccion { get; set; } = string.Empty;
        public string CC_Direccion { get; set; } = string.Empty;
        public string Des_Cuenta_Cta { get; set; } = string.Empty;
        public string Direccion_1_Cuenta_Cta { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty; 
        public string Telefono { get; set; } = string.Empty;
        public string Celular { get; set; } = string.Empty;
        public decimal Limite_Credito { get; set; }
        public bool Permitir_CxC { get; set; }
        public string Grupo_Cuenta { get; set; } = string.Empty;
        public string Des_Grupo_Cuenta { get; set; } = string.Empty;

    }
}
