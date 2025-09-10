namespace ClientService.Activities;

public record Activity(string Id, string What, string State, DateTime? DueDate, string? recipientId, string? Why, string? Notes);

public record GetWorkActivityListResponse(IEnumerable<Activity> Items);