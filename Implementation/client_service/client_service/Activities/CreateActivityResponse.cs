using System.Text.Json.Serialization;

namespace ClientService.Activities;

public record CreateActivityResponse(
    string Id,
    [property: JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    string[]? NoteIds);