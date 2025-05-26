using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc;

using MongoDB.Bson;
using MongoDB.Driver;

using client_service.Execution;
using client_service.Utilities;
using client_service.Validation;

namespace client_service.Work;

public static class HandlersWork
{
    #region METHODS
    
    public static void MapWorkURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/", ListWorkSummary).RequireCors(corsPolicyName);
        groupBuilder.MapGet("/{id}", GetWorkDetails).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/", Post).RequireCors(corsPolicyName);
        groupBuilder.MapPatch("/{id}", Patch).RequireCors(corsPolicyName);
        groupBuilder.MapDelete("/{id}", Delete).RequireCors(corsPolicyName);
    }
    
    public static void AddWorkValidation(this RequestValidation requestValidation)
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
        requestValidation.RegisterValidation(new ValidatedRequest(
            typeof(WorkCreateRequest), 
            typeof(WorkUpdateRequest), 
            new ValidatedPropertyCollection(properties.ToArray())
        ));
    }
    
    #endregion
    
    #region HTTP HANDLERS
    
    private static async Task<IResult> ListWorkSummary([FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.Find(filter).ToListAsync()", Executor.CategoryMongoDB, "Unable to obtain the list of work.", async () =>
        {
            var workItems = new List<WorkSummary>(); 
            IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
            var filter = Builders<DocumentWork>.Filter.Eq(p => p.UserId, ObjectId.Parse(httpRequest.GetSid())); 
            var workDocuments = await workCollection.Find(filter).ToListAsync(); 
            foreach (var document in workDocuments)
            {
                WorkSummary workSummaryItem = new WorkSummary(
                    document.Id.ToString(),
                    document.Name!,
                    document.Type,
                    document.Reference, 
                    document.Archived);
                workItems.Add(workSummaryItem);
            }
            return Results.Ok(new WorkSummaryListResponse(workItems));
        });
    }
    
    private static async Task<IResult> GetWorkDetails(string id, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.Find(filter).ToListAsync()", Executor.CategoryMongoDB, "Unable to obtain the list of work.", async () =>
        {
            IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
            var filter = Builders<DocumentWork>.Filter.Eq(p => p.Id, ObjectId.Parse(id)); 
            var workDocument = await workCollection.Find(filter).ToListAsync();
            return Results.NotFound($"Work with ID {id} not found.");
            if (workDocument.Count != 1)
                return Results.NotFound($"Work with ID {id} not found.");
            return Results.Ok(new WorkDetailsResponse(new WorkDetails(workDocument[0].Description)));
        });
    }

    private static async Task<IResult> Post([FromBody] WorkCreateRequest request, [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        var validationResults = requestValidation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.InsertOne(workDocument)", Executor.CategoryMongoDB, "Unable to save the new work", async () =>
            {
                IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
                DocumentWork? workDocument  = new DocumentWork
                {
                    UserId = ObjectId.Parse(httpRequest.GetSid()),
                    Name = request.Name!,
                    Type = request.Type,
                    Reference = request.Reference,
                    Description = request.Description
                };
                await workCollection.InsertOneAsync(workDocument);
                return Results.Created($"{_urlPrefix}/{workDocument.Id}", new WorkCreateResponse(workDocument.Id.ToString()));
            });
        }
        return Validation.RequestValidation.GenerateValidationFailedResponse(validationResults);
    }

    private static async Task<IResult> Patch(string id, WorkUpdateRequest request, [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger)
    {
        var validationResults = requestValidation.Validate(request);
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
                    UpdateResult result = await workCollection.UpdateOneAsync(filter, update!);
                    // Task.Delay(5000).GetAwaiter().GetResult();
                    return Results.NoContent();
                });
        }
        return Validation.RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> Delete(string id, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger)
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
    
    private const string CollectionName = "work";
    private static string? _urlPrefix;

    #endregion
}