namespace client_service.Work;

public static class WorkHandlers
{
    public static void MapWorkURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapPost("/", Post).RequireCors(corsPolicyName);
        groupBuilder.MapPatch("/", Patch).RequireCors(corsPolicyName);
        groupBuilder.MapDelete("/{id:int}", Delete).RequireCors(corsPolicyName);
    }

    private static WorkCreateResponse Post(WorkCreateRequest request, ILogger<Program> logger)
    {
         logger.LogInformation("POST {UrlPrefix}", _urlPrefix);
        return new WorkCreateResponse(123);
    }
    
    private static void Patch(WorkUpdateRequest request, ILogger<Program> logger)
    {
        logger.LogInformation("PATCH {UrlPrefix}", _urlPrefix);
    }
    
    private static void Delete(int id, ILogger<Program> logger)
    {
        logger.LogInformation("DELETE {UrlPrefix}/{Id}", _urlPrefix, id);
        throw new Exception("Test exception when deleting");
    }

    private static String? _urlPrefix;
}