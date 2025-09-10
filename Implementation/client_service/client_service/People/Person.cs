namespace ClientService.People;

public record Person : PersonDetails 
{
    public required string Id { get; init; }
}