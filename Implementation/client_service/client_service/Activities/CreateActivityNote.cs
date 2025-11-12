namespace ClientService.Activities;

public record class CreateActivityNote
{
    public required string Created { get; init; }
    
    public required string Text { get; init; }
}