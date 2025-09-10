namespace ClientService.People;

public record PersonDetails
{
    public required string FirstName { get; init; }
    
    public required string LastName { get; init; }
}