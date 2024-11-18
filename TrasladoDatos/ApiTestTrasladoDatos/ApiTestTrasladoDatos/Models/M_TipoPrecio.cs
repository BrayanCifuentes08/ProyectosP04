namespace ApiTestTrasladoDatos.Models
{
    public class M_TipoPrecio
    {
        public int pTipoPrecio { get; set; } = 0;
        public string pDescripcion { get; set; } = string.Empty;
        public string pUserName { get; set; } = string.Empty;
        public DateTime pFechaHora { get; set; }
        public string pMensaje { get; set; }
        public bool pResultado { get; set; }
    }
}
