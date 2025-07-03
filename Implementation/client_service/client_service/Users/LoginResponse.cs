namespace ClientService.Users;

public record class LoginResponse(string UserId, string[] WorkTypes);