namespace client_service.Work;

public record Work(object Id, string Name, string? Type, string? Reference);

public record WorkListResponse(IEnumerable<Work> Items);