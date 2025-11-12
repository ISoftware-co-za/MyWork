using ClientService.Validation;

namespace ClientService;

public record class ChangeEntityRequest(EntityProperty[]? UpdatedProperties, ChildEntityTypeInRequest[]? ChildUpdates);