namespace CuentasxCobrar.Model
{
    public class PaTblCargoAbonoM
    {
        public int TAccion { get; set; }
        public int Cargo_Abono { get; set; }
        public int Empresa { get; set; }
        public int Localizacion { get; set; }
        public int Estacion_Trabajo { get; set; }
        public int Fecha_Reg { get; set; }
        public int Tipo_Cargo_Abono { get; set; }
        public int Estado { get; set; }
        public DateTime Fecha_Hora { get; set; }
        public String UserName { get; set; }
        public DateTime? M_Fecha_Hora { get; set; }
        public String? M_UserName { get; set; }
        public decimal Monto { get; set; }
        public decimal Tipo_Cambio { get; set; }
        public int Moneda { get; set; }
        public decimal Monto_Moneda { get; set; }
        public String? Referencia { get; set; }
        public String? Autorizacion { get; set; }
        public int? Banco { get; set; }
        public String? Observacion_1 { get; set; }
        public int? Razon { get; set; }
        public int? D_Documento { get; set; }
        public int D_Tipo_Documento { get; set; }
        public String D_Serie_Documento { get; set; }
        public int D_Empresa { get; set; }
        public int D_Localizacion { get; set; }
        public int D_Estacion_Trabajo { get; set; }
        public int D_Fecha_Reg { get; set; }
        public decimal? Propina { get; set; }
        public decimal? Propina_Moneda { get; set; }
        public decimal? Monto_O { get; set; }
        public decimal? Monto_O_Moneda { get; set; }
        public int? F_Cuenta_Corriente_Padre { get; set; }
        public int? F_Cobrar_Pagar_Padre { get; set; }
        public int? F_Empresa_Padre { get; set; }
        public int? F_Localizacion_Padre { get; set; }
        public int? F_Estacion_Trabajo_Padre { get; set; }
        public int? F_Fecha_Reg_Padre { get; set; }
        public String? Ref_Documento { get; set; }
        public int? Cuenta_Bancaria { get; set; }
        public decimal? Propina_Monto { get; set; }
        public decimal? Propina_Monto_Moneda { get; set; }
        public int? Cuenta_PIN { get; set; }
        public int TOpcion { get; set; }
        public DateTime? Fecha_Ref { get; set; }
        public int? Consecutivo_Interno_Ref { get; set; }
        public String RecaptchaToken { get; set; }
        public bool IsMobile { get; set; }
    }
}
