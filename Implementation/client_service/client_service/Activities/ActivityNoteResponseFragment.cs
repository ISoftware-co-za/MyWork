namespace ClientService.Activities;

public record class ActivityNoteResponseFragment
{
    public required string Id { get; init; }
    public required string Created { get; init; }
    public required string Text { get; init; }
}