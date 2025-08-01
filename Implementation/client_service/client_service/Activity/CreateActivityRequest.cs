namespace ClientService.Activity;

public record class CreateActivityRequest
{
    public required string What { get; init; }
    
    public required string State { get; init; }
    
    public string? Why { get; init; }
    
    public string? Notes { get; init; }
    
    public String? DueDate { get; init; }
}