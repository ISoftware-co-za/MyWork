using System.ComponentModel.DataAnnotations;
using ClientService.Execution;
using ClientService.Utilities;
using ClientService.Validation;
using ClientService.Work;
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
        groupBuilder.MapPost("/{workID}", Post).RequireCors(corsPolicyName);
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
    
    private static async Task<IResult> Post(string workID, [FromBody] CreateActivityRequest request, [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        var validationResults = requestValidation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.InsertOne(activityDocument)", Executor.CategoryMongoDB, "Unable to save the new activity", async () =>
            {
                IMongoCollection<DocumentActivity> activityCollection = database.GetCollection<DocumentActivity>(CollectionName);
                DocumentActivity? activityDocument  = new DocumentActivity
                {
                    UserId = ObjectId.Parse(httpRequest.GetSid()),
                    WorkId = ObjectId.Parse(workID),
                    What = request.What,
                    State = ActivityState.Idle,
                    Why = request.Why,
                    Notes = request.Notes,
                    DueDate = request.DueDate
                };
                await activityCollection.InsertOneAsync(activityDocument);
                return Results.Created($"{_urlPrefix}/{activityDocument.Id}", new CreateActivityResponse(activityDocument.Id.ToString()));
            });
        }
        return Validation.RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    #endregion
    
    #region FIELDS
    
    private const string CollectionName = "activity";
    private static string? _urlPrefix;

    #endregion
}