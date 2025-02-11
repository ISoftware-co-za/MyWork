namespace client_service.Users;

public record class LoginResponse(string UserId, string[] WorkTypes);