namespace client_service.Work;

public record WorkUpdateField(string Name, object? Value);

public record WorkUpdateRequest(List<WorkUpdateField> UpdatedFields);