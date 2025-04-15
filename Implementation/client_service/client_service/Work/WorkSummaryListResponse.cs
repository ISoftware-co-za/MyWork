namespace client_service.Work;

public record WorkSummary(string Id, string Name, string? Type, string? Reference, bool Archived);

public record WorkSummaryListResponse(IEnumerable<WorkSummary> Items);

public record WorkDetails(string? Description);

public record WorkDetailsResponse(WorkDetails Details);