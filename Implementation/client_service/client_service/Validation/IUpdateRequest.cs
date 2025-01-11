namespace client_service.Validation;

public interface IUpdateRequest
{
    List<UpdateProperty> UpdatedProperties { get; }
}
