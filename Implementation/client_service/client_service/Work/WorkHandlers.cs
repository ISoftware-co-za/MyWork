using System.Diagnostics;
using MongoDB.Bson;
using MongoDB.Driver;

namespace client_service.Work;

public static class WorkHandlers
{
    public static void MapWorkURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/", Get).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/", Post).RequireCors(corsPolicyName);
        groupBuilder.MapPatch("/", Patch).RequireCors(corsPolicyName);
        groupBuilder.MapDelete("/{id}", Delete).RequireCors(corsPolicyName);
    }
    
    private static WorkListResponse Get(ILogger<Program> logger)
    {
        logger.LogInformation("GET {UrlPrefix}", _urlPrefix);
        return new WorkListResponse(new List<Work>
        {
            new Work(1, "Work 1", "Type 1", "Reference 1"),
            new Work(2, "Work 2", "Type 2", "Reference 2"),
            new Work(3, "Work 3", "Type 3", "Reference 3")
        });
        
    }

    private static WorkCreateResponse Post(WorkCreateRequest request, IMongoDatabase database, ILogger<Program> logger)
    {
        Stopwatch stopWatch = new();
        stopWatch.Start();
        IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
        var workDocument = new DocumentWork
        {
            Name = request.Name,
            Type = request.Type,
            Reference = request.Reference,
            Description = request.Description
        };
        workCollection.InsertOne(workDocument);
        stopWatch.Stop();
        logger.LogInformation("POST {UrlPrefix}/{Id} {Duration}ms", _urlPrefix, workDocument.Id, stopWatch.ElapsedMilliseconds);
        return new WorkCreateResponse(workDocument.Id.ToString());
    }
    
    private static void Patch(WorkUpdateRequest request, IMongoDatabase database, ILogger<Program> logger)
    {
        Stopwatch stopWatch = new();
        stopWatch.Start();
        var filter = Builders<DocumentWork>.Filter.Eq("_id", ObjectId.Parse(request.Id));
        UpdateDefinition<DocumentWork>? update = null;
        for (int index = 0; index < request.UpdatedProperties.Count; ++index)
        {
            if (index == 0)
                update = Builders<DocumentWork>.Update.Set(request.UpdatedProperties[index].Name, request.UpdatedProperties[index].Value);
            else
                update = update!.Set(request.UpdatedProperties[index].Name, request.UpdatedProperties[index].Value);
        }
        IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
        var result =  workCollection.UpdateOne(filter, update!);
        stopWatch.Stop();
        logger.LogInformation("PATCH {UrlPrefix} {UpdateCount}", _urlPrefix, result.MatchedCount);
    }
    
    private static async Task Delete(string id, IMongoDatabase database, ILogger<Program> logger)
    {
        IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
        var filter = Builders<DocumentWork>.Filter.Eq("_id", ObjectId.Parse(id));
        await workCollection.DeleteOneAsync(filter);
        logger.LogInformation("DELETE {UrlPrefix}/{Id}", _urlPrefix, id);
    }

    private static String? _urlPrefix;
    private const string CollectionName = "work";
}