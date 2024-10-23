using Newtonsoft.Json;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace CuentasxCobrar.Service
{
    public interface IRecaptchaService
    {
        Task<RecaptchaResponse> ValidateRecaptcha(string recaptchaToken);
    }


    public class RecaptchaService : IRecaptchaService
    {
        private readonly string _secretKey;

        public RecaptchaService(IConfiguration configuration)
        {
            _secretKey = configuration["Recaptcha:SecretKey"];
        }

        public async Task<RecaptchaResponse> ValidateRecaptcha(string recaptchaToken)
        {
            try
            {
                using (var client = new HttpClient())
                {
                    var response = await client.GetStringAsync($"https://www.google.com/recaptcha/api/siteverify?secret={_secretKey}&response={recaptchaToken}");
                    var captchaResponse = JsonConvert.DeserializeObject<RecaptchaResponse>(response);
                    return captchaResponse;
                }
            }
            catch (Exception ex)
            {
                // Log the exception details for debugging
                throw new ApplicationException("Error validating reCAPTCHA", ex);
            }
        }

    }


    public class RecaptchaResponse
    {
        public bool Success { get; set; }
        public string ChallengeTs { get; set; }
        public string Hostname { get; set; }
    }
}
