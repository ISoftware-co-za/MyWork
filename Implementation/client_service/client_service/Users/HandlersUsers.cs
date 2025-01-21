using System.ComponentModel.DataAnnotations;
using client_service.Execution;
using client_service.Validation;
using MongoDB.Bson;
using MongoDB.Driver;

namespace client_service.Users;

public static class HandlersUsers
{
    public static void MapUsersURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        _urlPrefix = urlPrefix;
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapPost("/login", PostLogin).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/{userID}/workTypes", PostWorkType).RequireCors(corsPolicyName);
    }
    
    public static void AddUserValidation(this Validation.Validation validation)
    {
        List<ValidatedProperty> loginRequestProperties =
        [
            new ValidatedProperty(nameof(LoginRequest.Email),
                [new RequiredNonWhitespaceAttribute(), new EmailAddressAttribute()]),
            new ValidatedProperty(nameof(LoginRequest.Password),
                [new RequiredNonWhitespaceAttribute(), new StringLengthAttribute(maximumLength: 80)]),
        ];
        validation.RegisterValidation(new ValidatedRequest(
            typeof(LoginRequest), 
            null, 
            new ValidatedPropertyCollection(loginRequestProperties.ToArray())
        ));
        
        List<ValidatedProperty> newWorkTypeProperties =
        [
            new ValidatedProperty(nameof(AddWorkTypeRequest.WorkType),
                [new RequiredNonWhitespaceAttribute(), new StringLengthAttribute(maximumLength: 50)]),
        ];
        validation.RegisterValidation(new ValidatedRequest(
            typeof(AddWorkTypeRequest), 
            null, 
            new ValidatedPropertyCollection(newWorkTypeProperties.ToArray())
        ));
    }
    
    private static async Task<IResult> PostLogin(LoginRequest request, Validation.Validation validation, IMongoDatabase database, ILogger<Program> logger, HttpContext httpContext)
    {
        var validationResults = validation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.InsertOne(workDocument)", Executor.CategoryMongoDB, "Unable to save the new work.", async () =>
            {
                var filter = Builders<DocumentUser>.Filter;
                await Task.Delay(1);
                return Results.NoContent();
            });
        }
        return Validation.Validation.GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> PostWorkType(string userId, AddWorkTypeRequest request, Validation.Validation validation, IMongoDatabase database, ILogger<Program> logger, HttpContext httpContext)
    {
        var validationResults = validation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.UpdateOneAsync(filter, update)", Executor.CategoryMongoDB, "Unable to add a work type.", async () =>
            {
                var filter = Builders<DocumentUser>.Filter.Eq("_id", ObjectId.Parse(userId));
                
                var users = await database.GetCollection<DocumentUser>(CollectionName).Find(new BsonDocument()).ToListAsync();
                var document = await database.GetCollection<DocumentUser>(CollectionName).Find(filter).FirstOrDefaultAsync();
                
                var update = Builders<DocumentUser>.Update.AddToSet(u => u.WorkTypes, request.WorkType);
                var result = await database.GetCollection<DocumentUser>(CollectionName).UpdateOneAsync(filter, update);
                return result.ModifiedCount == 1 ? Results.NoContent() : Results.NotFound();
            });
        }
        return Validation.Validation.GenerateValidationFailedResponse(validationResults);
    }
    
    #region FIELDS

    private static String? _urlPrefix;
    private const string CollectionName = "users";
    
    #endregion
}