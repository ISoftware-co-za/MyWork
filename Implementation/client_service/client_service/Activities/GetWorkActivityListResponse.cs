namespace ClientService.Activities;

public record Activity(string Id, string What, string State, DateTime? DueDate, string? RecipientId, string? Why, string? How, ActivityNoteResponseFragment[]? Notes);

public record GetWorkActivityListResponse(IEnumerable<Activity> Items);