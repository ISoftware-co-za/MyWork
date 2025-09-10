using ClientService.Validation;

namespace ClientService.Activities;

public record UpdateActivityRequest(List<UpdateProperty> UpdatedProperties) : IUpdateRequest;