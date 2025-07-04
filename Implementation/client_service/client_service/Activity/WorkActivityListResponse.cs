namespace ClientService.Activity;

public record Activity(string Id, string What, string State, string? Why, string? Notes, DateTime? DueDate);

public record WorkActivityListResponse(IEnumerable<Activity> Items);