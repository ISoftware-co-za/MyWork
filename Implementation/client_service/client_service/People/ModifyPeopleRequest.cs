namespace ClientService.People;

public record ModifyPeopleRequest
{
    public PersonDetails[]? AddedPeople { get; init; }
    
    public UpdatedPerson[]? UpdatedPeople { get; init; }
    
    public string[]? RemovedPersonIds { get; init; }
}