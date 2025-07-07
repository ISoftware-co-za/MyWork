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
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapGet("/{workID}/activities", ListALlWorkActivities).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/{workID}/activities", Post).RequireCors(corsPolicyName);
        groupBuilder.MapPatch("/{workID}/activities/{id}", Patch).RequireCors(corsPolicyName);
    }

    public static void AddActivityValidation(this RequestValidation requestValidation)
    {
        List<ValidatedProperty> properties =
        [
            new ValidatedProperty(nameof(CreateActivityRequest.What),
                [new RequiredAttribute(), new StringLengthAttribute(maximumLength: 80)]),
            new ValidatedProperty(nameof(CreateActivityRequest.Why),
                [new StringLengthAttribute(maximumLength: 240)]),
            new ValidatedProperty(nameof(CreateActivityRequest.Notes),
                [new StringLengthAttribute(maximumLength: 240)])
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
                IMongoCollection<DocumentActivity> activityCollection =
                    database.GetCollection<DocumentActivity>(CollectionName);
                var filter = Builders<DocumentActivity>.Filter.And(
                    Builders<DocumentActivity>.Filter.Eq(p => p.UserId, ObjectId.Parse(httpRequest.GetSid())),
                    Builders<DocumentActivity>.Filter.Eq(p => p.WorkId, ObjectId.Parse(workID))
                );
                var activityDocuments = await activityCollection.Find(filter).ToListAsync();
                foreach (var document in activityDocuments)
                {
                    var activity = new Activity(
                        document.Id.ToString(),
                        document.What,
                        document.State.ToString(),
                        document.Why,
                        document.Notes,
                        document.DueDate);
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
        {
            return await Executor.RunProcessAsync($"{CollectionName}.InsertOne(activityDocument)",
                Executor.CategoryMongoDB, "Unable to save the new activity", async () =>
                {
                    IMongoCollection<DocumentActivity> activityCollection =
                        database.GetCollection<DocumentActivity>(CollectionName);
                    DocumentActivity? activityDocument = new DocumentActivity
                    {
                        UserId = ObjectId.Parse(httpRequest.GetSid()),
                        WorkId = ObjectId.Parse(workID),
                        What = request.What,
                        State = Enum.Parse<ActivityState>(request.State, true),
                        Why = request.Why,
                        Notes = request.Notes,
                        DueDate = request.DueDate
                    };
                    await activityCollection.InsertOneAsync(activityDocument);
                    return Results.Created($"{_urlPrefix}/{activityDocument.Id}",
                        new CreateActivityResponse(activityDocument.Id.ToString()));
                });
        }

        return Validation.RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> Patch(string workID, string id, UpdateEntityRequest request, [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger)
    {
        var validationResults = requestValidation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.UpdateOneAsync({id})", Executor.CategoryMongoDB, "Unable to save the updated work",
                async () =>
                {
                    var filter = Builders<DocumentActivity>.Filter.Eq("_id", ObjectId.Parse(id));
                    UpdateDefinition<DocumentActivity>? update = null;
                    for (int index = 0; index < request.UpdatedProperties.Count; ++index)
                    {
                        UpdateProperty updateProperty = request.UpdatedProperties[index];
                        object? value = DeserializeUpdateValue(updateProperty.Name, updateProperty.Value);
                        if (index == 0)
                            update = Builders<DocumentActivity>.Update.Set(updateProperty.Name, value);
                        else
                            update = update!.Set(updateProperty.Name, value);
                    }
                    IMongoCollection<DocumentActivity> activityCollection = database.GetCollection<DocumentActivity>(CollectionName);
                    await activityCollection.UpdateOneAsync(filter, update!);
                    return Results.NoContent();
                });
        }
        return Validation.RequestValidation.GenerateValidationFailedResponse(validationResults);
    }

    private static object? DeserializeUpdateValue(string name, object? value)
    {
        if (value == null)
            return value;
        if (name == nameof(DocumentActivity.State))
            return Enum.Parse(typeof(ActivityState), value.ToString()!, true);
        return value;
    }

    #endregion

    #region FIELDS

    private const string CollectionName = "activity";
    private static string? _urlPrefix;

    #endregion
}