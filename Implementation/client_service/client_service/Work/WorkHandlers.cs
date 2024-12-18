using System.ComponentModel.DataAnnotations;
using System.Diagnostics;
using client_service.Validation;
using Microsoft.Extensions.Logging.Abstractions;
using MongoDB.Bson;
using MongoDB.Driver;

namespace client_service.Work;

public static class WorkHandlers
{
    #region METHODS
    
    public static void MapWorkURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/", Get).RequireCors(corsPolicyName);
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
    
    #endregion
    
    #region PRIVATE METHODS

    private static IResult Post(WorkCreateRequest request, Validation.Validation validation, IMongoDatabase database, ILogger<Program> logger)
    {
        var validationResults = validation.Validate(request);
        if (validationResults.Length == 0)
        {
            Stopwatch stopWatch = new();
            stopWatch.Start();
            IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
            var workDocument = new DocumentWork
            {
                Name = request.Name!,
                Type = request.Type,
                Reference = request.Reference,
                Description = request.Description
            };
            workCollection.InsertOne(workDocument);
            stopWatch.Stop();
            var url = $"{_urlPrefix}/{workDocument.Id}";
            logger.LogInformation("POST {Url} {Duration}ms", url, stopWatch.ElapsedMilliseconds);
            // Task.Delay(5000).GetAwaiter().GetResult();
            return Results.Created($"{_urlPrefix}/{workDocument.Id}", new WorkCreateResponse(workDocument.Id.ToString()));
        }
        return GenerateValidationFailedResponse(validationResults);
    }

    private static IResult Patch(string id, WorkUpdateRequest request, Validation.Validation validation, IMongoDatabase database, ILogger<Program> logger)
    {
        var validationResults = validation.Validate(request);
        if (validationResults.Length == 0)
        {
            Stopwatch stopWatch = new();
            stopWatch.Start();
            var filter = Builders<DocumentWork>.Filter.Eq("_id", ObjectId.Parse(id));
            UpdateDefinition<DocumentWork>? update = null;
            for (int index = 0; index < request.UpdatedProperties.Count; ++index)
            {
                if (index == 0)
                    update = Builders<DocumentWork>.Update.Set(request.UpdatedProperties[index].Name,
                        request.UpdatedProperties[index].Value);
                else
                    update = update!.Set(request.UpdatedProperties[index].Name, request.UpdatedProperties[index].Value);
            }

            IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
            var result = workCollection.UpdateOne(filter, update!);
            stopWatch.Stop();
            logger.LogInformation("PATCH {UrlPrefix} {UpdateCount}", _urlPrefix, result.MatchedCount);
            // Task.Delay(5000).GetAwaiter().GetResult();
            return Results.NoContent();
        }
        return GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> Delete(string id, IMongoDatabase database, ILogger<Program> logger)
    {
        IMongoCollection<DocumentWork> workCollection = database.GetCollection<DocumentWork>(CollectionName);
        var filter = Builders<DocumentWork>.Filter.Eq("_id", ObjectId.Parse(id));
        await workCollection.DeleteOneAsync(filter);
        logger.LogInformation("DELETE {UrlPrefix}/{Id}", _urlPrefix, id);
        return Results.NoContent();
    }
    
    private static IResult GenerateValidationFailedResponse(ValidationResult[] validationResults)
    {
        var consolidatedError = new Dictionary<string, string[]>();
        foreach(var validationResult in validationResults)
        {
            foreach(var memberName in validationResult.MemberNames)
            {
                if (consolidatedError.TryGetValue(memberName, out var value))
                    value.Append(validationResult.ErrorMessage);
                else
                    consolidatedError[memberName.ToLower()] = [validationResult.ErrorMessage];
            }
        }
        return Results.ValidationProblem(consolidatedError);
    }
    
    #endregion
    
    #region FIELDS

    private static String? _urlPrefix;
    private const string CollectionName = "work";
    
    #endregion
}