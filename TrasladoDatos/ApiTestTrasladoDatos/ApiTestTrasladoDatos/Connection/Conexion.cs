namespace ApiTestTrasladoDatos.Connection
{
    public class Conexion
    {
        private string connectionString = string.Empty;

        public Conexion() {
            var constructor = new ConfigurationBuilder().SetBasePath
            (Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json").Build();
            connectionString = constructor.GetSection("ConnectionStrings:ConnectionString").Value;
        }

        public string cadenaSQL()
        {
            return connectionString;
        }
    }
}
