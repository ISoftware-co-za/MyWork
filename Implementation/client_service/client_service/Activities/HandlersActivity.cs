using System.ComponentModel.DataAnnotations;
using ClientService.Execution;
using ClientService.Utilities;
using ClientService.Validation;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

namespace ClientService.Activities;

public static class HandlersActivity
{
    #region METHODS

    public static void MapActivityURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        var groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/{workID}/activities", ListALlWorkActivities).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/{workID}/activities", Post).RequireCors(corsPolicyName);
        groupBuilder.MapPatch("/{workID}/activities/{id}", Patch).RequireCors(corsPolicyName);
        groupBuilder.MapDelete("/{workID}/activities/{id}", Delete).RequireCors(corsPolicyName);
    }

    public static void AddActivityValidation(this RequestValidation requestValidation)
    {
        List<ValidatedProperty> properties =
        [
            new(nameof(CreateActivityRequest.What),
                [new RequiredAttribute(), new StringLengthAttribute(80)]),
            new(nameof(CreateActivityRequest.Why),
                [new StringLengthAttribute(240)]),
            new(nameof(CreateActivityRequest.Notes),
                [new StringLengthAttribute(240)])
        ];
        requestValidation.RegisterValidation(new ValidatedRequest(
            typeof(CreateActivityRequest),
            typeof(UpdateActivityRequest),
            new ValidatedPropertyCollection(properties.ToArray())
        ));
    }
    
    public static async Task DeleteWorkActivities(string workID, IMongoDatabase database)
    {
        await Executor.RunProcessAsync($"{CollectionName}.DeleteManyAsync({workID})", Executor.CategoryMongoDB,
            "Unable to delete activities for work with id ${workID}",
            async () =>
            {
                var filter = Builders<DocumentActivity>.Filter.Eq("work_id", ObjectId.Parse(workID));
                var activityCollection =
                    database.GetCollection<DocumentActivity>(CollectionName);
                await activityCollection.DeleteManyAsync(filter);
                return Results.NoContent();
            });
    }

    #endregion

    #region PRIVATE HANDLERS

    private static async Task<IResult> ListALlWorkActivities(string workID, [FromServices] IMongoDatabase database,
        [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.Find(filter).ToListAsync()", Executor.CategoryMongoDB,
            "Unable to obtain the list of activities for the work.", async () =>
            {
                var activityItems = new List<Activity>();
                var activityCollection =
                    database.GetCollection<DocumentActivity>(CollectionName);
                var userId = httpRequest.GetSid();
                var filter = Builders<DocumentActivity>.Filter.And(
                    Builders<DocumentActivity>.Filter.Eq(p => p.UserId, ObjectId.Parse(userId)),
                    Builders<DocumentActivity>.Filter.Eq(p => p.WorkId, ObjectId.Parse(workID))
                );
                var activityDocuments = await activityCollection.Find(filter).ToListAsync();
                foreach (var document in activityDocuments)
                {
                    DateTime? dueDate = null;
                    if (document.DueDate != null)
                    {
                        dueDate = DateTime.Parse(document.DueDate);
                    }
                    var activity = new Activity(
                        document.Id.ToString(),
                        document.What,
                        document.State.ToString(),
                        dueDate,
                        document.RecipientId?.ToString(),
                        document.Why,
                        document.Notes);
                    activityItems.Add(activity);
                }
                return Results.Ok(new GetWorkActivityListResponse(activityItems));
            });
    }

    private static async Task<IResult> Post(string workID, [FromBody] CreateActivityRequest request,
        [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database,
        [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        var validationResults = requestValidation.Validate(request);
        if (validationResults.Length == 0)
            return await Executor.RunProcessAsync($"{CollectionName}.InsertOne(activityDocument)",
                Executor.CategoryMongoDB, "Unable to save the new activity", async () =>
                {
                    var activityCollection =
                        database.GetCollection<DocumentActivity>(CollectionName);
                    var activityDocument = new DocumentActivity
                    {
                        UserId = ObjectId.Parse(httpRequest.GetSid()),
                        WorkId = ObjectId.Parse(workID),
                        What = request.What,
                        State = Enum.Parse<ActivityState>(request.State, true),
                        DueDate = request.DueDate,
                        RecipientId = string.IsNullOrWhiteSpace(request.RecipientId)
                            ? null
                            : ObjectId.Parse(request.RecipientId!),
                        Why = request.Why,
                        Notes = request.Notes,
                    };
                    await activityCollection.InsertOneAsync(activityDocument);
                    return Results.Created($"{_urlPrefix}/{activityDocument.Id}",
                        new CreateActivityResponse(activityDocument.Id.ToString()));
                });

        return RequestValidation.GenerateValidationFailedResponse(validationResults);
    }

    private static async Task<IResult> Patch(string workID, string id, UpdateEntityRequest request,
        [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database,
        [FromServices] ILogger<Program> logger)
    {
        var validationResults = requestValidation.Validate(request);
        if (validationResults.Length == 0)
            return await Executor.RunProcessAsync($"{CollectionName}.UpdateOneAsync({id})", Executor.CategoryMongoDB,
                "Unable to save the updated activity",
                async () =>
                {
                    var filter = Builders<DocumentActivity>.Filter.Eq("_id", ObjectId.Parse(id));
                    List<UpdateDefinition<DocumentActivity>> updates = [];
                    foreach (var updateProperty in request.UpdatedProperties)
                    {
                        var value = DeserializeUpdateValue(updateProperty.NameInPascalCase(), updateProperty.Value);
                        updates.Add(Builders<DocumentActivity>.Update.Set(updateProperty.NameInPascalCase(), value));
                    }
                    var activityCollection = database.GetCollection<DocumentActivity>(CollectionName);
                    UpdateDefinition<DocumentActivity> combinedUpdates =
                        Builders<DocumentActivity>.Update.Combine(updates);
                    UpdateResult result = await activityCollection.UpdateOneAsync(filter, combinedUpdates);
                    if (result.IsAcknowledged == false || result.MatchedCount != 1)
                    {
                        ProblemDetails details = new ProblemDetails
                        {
                            Title = "Activity not found",
                            Status = 404,
                            Detail = $"Activity with id {id} could not be updated as it was not found."
                        };
                        return Results.NotFound(details);
                    }
                    return Results.NoContent();
                });
        return RequestValidation.GenerateValidationFailedResponse(validationResults);
    }

    private static async Task<IResult> Delete(string workID, string id, IMongoDatabase database,
        [FromServices] ILogger<Program> logger)
    {
        return await Executor.RunProcessAsync($"{CollectionName}.DeleteOneAsync({id})", Executor.CategoryMongoDB,
            "Unable to save the updated work",
            async () =>
            {
                var filter = Builders<DocumentActivity>.Filter.Eq("_id", ObjectId.Parse(id));
                var activityCollection =
                    database.GetCollection<DocumentActivity>(CollectionName);
                await activityCollection.DeleteOneAsync(filter);
                return Results.NoContent();
            });
    }
    
    private static object? DeserializeUpdateValue(string name, object? value)
    {
        if (value == null)
            return value;
        if (name == nameof(DocumentActivity.State))
            return Enum.Parse(typeof(ActivityState), value.ToString()!, true);
        if (name == nameof(DocumentActivity.RecipientId))
            return ObjectId.Parse(value.ToString()!);
        return value;
    }

    #endregion

    #region FIELDS

    private const string CollectionName = "activities";
    private static string? _urlPrefix;

    #endregion
}