namespace CuentasxCobrar.Model
{
    public class PaBscCuentaBancaria1M
    {
        public int Cuenta_Bancaria { get; set; }
        public string Descripcion { get; set; }
        public int Banco { get; set; }
        public string Id_Cuenta_Bancaria { get; set; }
        public decimal Ban_Ini { get; set; }
        public decimal Ban_Ini_Mes { get; set; }
        public int Cuenta { get; set; }
        public int Num_Doc { get; set; }
        public decimal Saldo { get; set; }
        public bool Estado { get; set; }
        public string Lugar { get; set; }
        public decimal Ban_Ini_Dia { get; set; }
        public DateTime Fecha_Hora { get; set; }
        public string UserName { get; set; }
        public DateTime M_Fecha_Hora { get; set; }
        public string M_UserName { get; set; }
        public string Orden { get; set; }
        public int Serie_Ini { get; set; }
        public int Serie_Fin { get; set; }
        public int Moneda { get; set; }
        public int? Cuenta_M { get; set; }
    }
}
