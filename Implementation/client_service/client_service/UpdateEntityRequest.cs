using ClientService.Validation;

namespace ClientService;

public record UpdateEntityRequest(List<UpdateProperty> UpdatedProperties) : IUpdateRequest;