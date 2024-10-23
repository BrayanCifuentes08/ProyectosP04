public class PaBscCuentaCorriente1M
{
    public int pCuenta_Correntista { get; set; }
    public string pCuenta_Cta { get; set; }
    public byte pEmpresa { get; set; }
    public byte pCobrar_Pagar { get; set; }
    public bool pSaldo { get; set; }
    public int? pReferencia { get; set; }
    public string pFil_Documento_Relacion { get; set; }
    public string pUserName { get; set; } = string.Empty;
    public decimal? pTotal_Monto { get; set; }
    public decimal? pTotal_Aplicado { get; set; }
    public decimal? pTotal_Saldo { get; set; }
    public decimal? pSel_Monto { get; set; }
    public decimal? pSel_Aplicado { get; set; }
    public decimal? pSel_Saldo { get; set; }
    public byte pOpcion_Orden { get; set; }
    public string pSQL_str { get; set; } = string.Empty;
    public bool? pFecha_Documento { get; set; }
}
