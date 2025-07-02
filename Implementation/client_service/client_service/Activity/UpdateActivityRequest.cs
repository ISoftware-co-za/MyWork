using ClientService.Validation;

namespace ClientService.Activity;

public record UpdateActivityRequest(List<UpdateProperty> UpdatedProperties) : IUpdateRequest;