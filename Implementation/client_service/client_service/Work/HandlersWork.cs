using MongoDB.Bson;
using MongoDB.Driver;
using System.ComponentModel.DataAnnotations;
using client_service.Execution;
using client_service.Validation;

namespace client_service.Work;

public static class HandlersWork
{
    #region METHODS
    
    public static void MapWorkURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/{userId}", ListWork).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/", Post).RequireCors(corsPolicyName);
        groupBuilder.MapPatch("/{id}", Patch).RequireCors(corsPolicyName);
        groupBuilder.MapDelete("/{id}", Delete).RequireCors(corsPolicyName);
    }
    
    public static void AddWorkValidation(this Validation.Validation validation)
    {
        List<ValidatedProperty> properties =
        [
            new ValidatedProperty(nameof(WorkCreateRequest.Name),
                [new RequiredAttribute(), new StringLengthAttribute(maximumLength: 80)]),
            new ValidatedProperty(nameof(WorkCreateRequest.Type),
                [new StringLengthAttribute(maximumLength: 40)]),
            new ValidatedProperty(nameof(WorkCreateRequest.Reference),
                [new StringLengthAttribute(maximumLength: 40)])
        ];
        validation.RegisterValidation(new ValidatedRequest(
            typeof(WorkCreateRequest), 
            typeof(WorkUpdateRequest), 
            new ValidatedPropertyCollection(properties.ToArray())
        ));
    }
    
    private static async Task<IResult> ListWork(string userId, IMongoDatabase database, ILogger<Program> logger)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.Find(filter).ToListAsync()", Executor.CategoryMongoDB, "Unable to obtain the list of work.", async () =>
        {
            var workItems = new List<Work>(); 
            IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
            var filter = Builders<DocumentWork>.Filter.Eq(p => p.UserId, ObjectId.Parse(userId)); 
            var workDocuments = await workCollection.Find(filter).ToListAsync(); 
            foreach (var document in workDocuments)
            {
                Work workItem = new Work(
                    document.Id,
                    document.Name!,
                    document.Type,
                    document.Reference,
                    document.Description);
                workItems.Add(workItem);
            }
            return Results.Ok(new WorkListResponse(workItems));
        });
    }
    
    #endregion
    
    #region PRIVATE METHODS

    private static async Task<IResult> Post(WorkCreateRequest request, Validation.Validation validation, IMongoDatabase database, ILogger<Program> logger, HttpContext httpContext)
    {
        var validationResults = validation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.InsertOne(workDocument)", Executor.CategoryMongoDB, "Unable to save the new work", async () =>
            {
                IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
                DocumentWork? workDocument  = new DocumentWork
                {
                    Name = request.Name!,
                    Type = request.Type,
                    Reference = request.Reference,
                    Description = request.Description
                };
                await workCollection.InsertOneAsync(workDocument);
                // Task.Delay(5000).GetAwaiter().GetResult();
                return Results.Created($"{_urlPrefix}/{workDocument!.Id}", new WorkCreateResponse(workDocument.Id.ToString()));
            });
        }
        return Validation.Validation.GenerateValidationFailedResponse(validationResults);
    }

    private static async Task<IResult> Patch(string id, WorkUpdateRequest request, Validation.Validation validation, IMongoDatabase database, ILogger<Program> logger)
    {
        var validationResults = validation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.UpdateOneAsync({id})", Executor.CategoryMongoDB, "Unable to save the updated work",
                async () =>
                {
                    var filter = Builders<DocumentWork>.Filter.Eq("_id", ObjectId.Parse(id));
                    UpdateDefinition<DocumentWork>? update = null;
                    for (int index = 0; index < request.UpdatedProperties.Count; ++index)
                    {
                        if (index == 0)
                            update = Builders<DocumentWork>.Update.Set(request.UpdatedProperties[index].Name,
                                request.UpdatedProperties[index].Value);
                        else
                            update = update!.Set(request.UpdatedProperties[index].Name,
                                request.UpdatedProperties[index].Value);
                    }
                    IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
                    await workCollection.UpdateOneAsync(filter, update!);
                    // Task.Delay(5000).GetAwaiter().GetResult();
                    return Results.NoContent();
                });
        }
        return Validation.Validation.GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> Delete(string id, IMongoDatabase database, ILogger<Program> logger)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.DeleteOneAsync({id})", Executor.CategoryMongoDB, "Unable to delete the work",
            async () =>
            {
                IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
                var filter = Builders<DocumentWork>.Filter.Eq("_id", ObjectId.Parse(id));
                await workCollection.DeleteOneAsync(filter);
                return Results.NoContent();
            });
    }
    
    #endregion
    
    #region FIELDS

    private static String? _urlPrefix;
    private const string CollectionName = "work";
    
    #endregion
}