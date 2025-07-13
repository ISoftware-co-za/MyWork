using System.ComponentModel.DataAnnotations;
using ClientService.Execution;
using ClientService.Utilities;
using ClientService.Validation;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

namespace ClientService.Activity;

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
                var filter = Builders<DocumentActivity>.Filter.And(
                    Builders<DocumentActivity>.Filter.Eq(p => p.UserId, ObjectId.Parse(httpRequest.GetSid())),
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
                        document.Why,
                        document.Notes,
                        dueDate);
                    activityItems.Add(activity);
                }

                return Results.Ok(new WorkActivityListResponse(activityItems));
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
                        Why = request.Why,
                        Notes = request.Notes,
                        DueDate = request.DueDate?.ToString("0")
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
                "Unable to save the updated work",
                async () =>
                {
                    var filter = Builders<DocumentActivity>.Filter.Eq("_id", ObjectId.Parse(id));
                    UpdateDefinition<DocumentActivity>? update = null;
                    for (var index = 0; index < request.UpdatedProperties.Count; ++index)
                    {
                        var updateProperty = request.UpdatedProperties[index];
                        var value = DeserializeUpdateValue(updateProperty.Name, updateProperty.Value);
                        if (index == 0)
                            update = Builders<DocumentActivity>.Update.Set(updateProperty.Name, value);
                        else
                            update = update!.Set(updateProperty.Name, value);
                    }

                    var activityCollection = database.GetCollection<DocumentActivity>(CollectionName);
                    await activityCollection.UpdateOneAsync(filter, update!);
                    return Results.NoContent();
                });
        return RequestValidation.GenerateValidationFailedResponse(validationResults);
    }

    private static object? DeserializeUpdateValue(string name, object? value)
    {
        if (value == null)
            return value;
        if (name == nameof(DocumentActivity.State))
            return Enum.Parse(typeof(ActivityState), value.ToString()!, true);
        if (name == nameof(DocumentActivity.DueDate))
            return DateTime.Parse(value.ToString()!);
        return value;
    }

    #endregion

    #region FIELDS

    private const string CollectionName = "activity";
    private static string? _urlPrefix;

    #endregion
}