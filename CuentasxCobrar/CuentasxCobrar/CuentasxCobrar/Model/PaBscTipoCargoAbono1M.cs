namespace CuentasxCobrar.Model
{
    public class PaBscTipoCargoAbono1M
    {
        public int Tipo_Cargo_Abono { get; set; }
        public string Descripcion { get; set; }
        public decimal Monto { get; set; }
        public int Referencia { get; set; }
        public int Autorizacion { get; set; }
        public decimal Calcular_Monto { get; set; }
        public int Cuenta_Corriente { get; set; }
        public bool Reservacion { get; set; }
        public bool Factura { get; set; }
        public bool Efectivo { get; set; }
        public bool Banco { get; set; }
        public bool Fecha_Vencimiento { get; set; }
        public decimal Comision_Porcentaje { get; set; }
        public decimal Comision_Monto { get; set; }
        public int? Cuenta { get; set; }
        public bool Contabilizar { get; set; }
        public bool Val_Limite_Credito { get; set; }
        public bool Msg_Limite_Credito { get; set; }
        public int? Cuenta_Correntista { get; set; }
        public int? Cuenta_Cta { get; set; }
        public bool Bloquear_Documento { get; set; }
        public string URL { get; set; }
        public int? Req_Cuenta_Bancaria { get; set; }
        public int? Req_Ref_Documento { get; set; }
        public int? Req_Fecha { get; set; }

    }
}
