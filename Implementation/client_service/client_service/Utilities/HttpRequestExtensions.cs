using System.Security.Claims;

namespace ClientService.Utilities;

public static class HttpRequestExtensions
{
    public static string GetSid(this HttpRequest request)
    {
        return  request.HttpContext.User.Claims.First(c => c.Type == ClaimTypes.Sid).Value;
    }
}