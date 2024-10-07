namespace client_service.Work;

public record WorkCreateRequest(string Name, string? Type, string? Reference, string? Description);