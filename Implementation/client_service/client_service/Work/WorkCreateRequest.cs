namespace client_service.Work;

public record class WorkCreateRequest
{
    public required string Name { get; init; }
    
    public string? Type { get; init; }
    
    public string? Reference { get; init; }
    
    public string? Description { get; init; }
}