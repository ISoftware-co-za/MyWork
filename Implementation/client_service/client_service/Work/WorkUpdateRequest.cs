using client_service.Validation;

namespace client_service.Work;

public record WorkUpdateRequest(List<UpdateProperty> UpdatedProperties) : IUpdateRequest;