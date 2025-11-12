namespace ClientService.People;

public record UpdatedPerson
{
    public required string Id { get; init; }
    
    public required EntityProperty[] UpdatedProperties { get; init; }
}