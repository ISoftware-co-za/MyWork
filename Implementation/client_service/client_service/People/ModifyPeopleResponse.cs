namespace ClientService.People;

public record ModifyPeopleResponse
{
    public string? AddedPeopleErrorMessage { get; set; }
    public ModifyOutcome[]? AddedPeople { get; init; }
    
    public string? UpdatedPeopleErrorMessage { get; set; }
    public ModifyOutcome[]? UpdatedPeople { get; init; }
    
    public string? RemovedPeopleErrorMessage { get; set; }
    public ModifyOutcome[]? RemovedPeople { get; init; }
}