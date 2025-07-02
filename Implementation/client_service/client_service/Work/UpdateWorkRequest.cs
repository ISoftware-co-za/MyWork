using ClientService.Validation;

namespace ClientService.Work;

public record UpdateWorkRequest(List<UpdateProperty> UpdatedProperties) : IUpdateRequest;