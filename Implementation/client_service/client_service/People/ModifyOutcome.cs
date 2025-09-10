namespace ClientService.People;

public record ModifyOutcome
{
    public required string Id { get; set; }
    
    public string? ErrorMessage { get; set; }
}