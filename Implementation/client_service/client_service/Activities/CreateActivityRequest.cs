namespace ClientService.Activities;

public record class CreateActivityRequest
{
    public required string What { get; init; }
    
    public required string State { get; init; }
       
    public string? RecipientId { get; init; }
    
    public string? DueDate { get; init; }
    
    public string? Why { get; init; }
    
    public string? How { get; init; }
}