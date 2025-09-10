namespace ClientService.People;

public record UpdatedPerson
{
    public required string Id { get; init; }
    
    public required UpdateProperty[] UpdatedProperties { get; init; }
}