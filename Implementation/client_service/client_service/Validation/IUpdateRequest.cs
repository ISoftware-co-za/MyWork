namespace ClientService.Validation;

public interface IUpdateRequest
{
    List<UpdateProperty> UpdatedProperties { get; }
}
