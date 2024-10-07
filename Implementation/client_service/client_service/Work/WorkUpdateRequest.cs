namespace client_service.Work;

public record WorkUpdateField(string Name, object? Value);

public record WorkUpdateRequest(string Id, List<WorkUpdateField> UpdatedProperties);