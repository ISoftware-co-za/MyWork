namespace ClientService.People;

public record GetAllPeopleResponse
{
    public required Person[] People { get; init; }
}