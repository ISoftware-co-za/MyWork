using System.ComponentModel.DataAnnotations;
using client_service.Execution;
using client_service.Validation;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

namespace client_service.Users;

public static class HandlersUsers
{
    #region METHODS
    
    public static void MapUsersURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapPost("/login", PostLogin).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/{userID}/workTypes", PostWorkType).RequireCors(corsPolicyName);
    }
    
    public static void AddUserValidation(this Validation.RequestValidation requestValidation)
    {
        List<ValidatedProperty> loginRequestProperties =
        [
            new ValidatedProperty(nameof(LoginRequest.Email),
                [new RequiredNonWhitespaceAttribute(), new EmailAddressAttribute()]),
            new ValidatedProperty(nameof(LoginRequest.Password),
                [new RequiredNonWhitespaceAttribute(), new StringLengthAttribute(maximumLength: 80)]),
        ];
        requestValidation.RegisterValidation(new ValidatedRequest(
            typeof(LoginRequest), 
            null, 
            new ValidatedPropertyCollection(loginRequestProperties.ToArray())
        ));
        
        List<ValidatedProperty> newWorkTypeProperties =
        [
            new ValidatedProperty(nameof(AddWorkTypeRequest.WorkType),
                [new RequiredNonWhitespaceAttribute(), new StringLengthAttribute(maximumLength: 50)]),
        ];
        requestValidation.RegisterValidation(new ValidatedRequest(
            typeof(AddWorkTypeRequest), 
            null, 
            new ValidatedPropertyCollection(newWorkTypeProperties.ToArray())
        ));
    }
    
    #endregion
    
    #region PRIVATE METHODS
    
    private static async Task<IResult> PostLogin([FromBody] LoginRequest request, [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpContext httpContext)
    {
        var validationResults = requestValidation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.Find(filter).FirstOrDefaultAsync();", Executor.CategoryMongoDB, "Unable to login user.", async () =>
            {
                var filter = Builders<DocumentUser>.Filter.And(
                    Builders<DocumentUser>.Filter.Eq(u => u.Email, request.Email.ToLower()),
                    Builders<DocumentUser>.Filter.Eq(u => u.Password, request.Password)
                );
                var user = await database.GetCollection<DocumentUser>(CollectionName).Find(filter).FirstOrDefaultAsync();
                if (user != null)
                {
                    var response = new LoginResponse(user.Id.ToString(), user.WorkTypes);
                    return Results.Ok(response);
                }
                return Results.Forbid();
            });
        }
        return RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> PostWorkType(string userId, AddWorkTypeRequest request, [FromServices]  RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpContext httpContext)
    {
        var validationResults = requestValidation.Validate(request);
        if (validationResults.Length == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.UpdateOneAsync(filter, update)", Executor.CategoryMongoDB, "Unable to add a work type.", async () =>
            {
                var filter = Builders<DocumentUser>.Filter.Eq("_id", ObjectId.Parse(userId));
                var update = Builders<DocumentUser>.Update.AddToSet(u => u.WorkTypes, request.WorkType);
                var result = await database.GetCollection<DocumentUser>(CollectionName).UpdateOneAsync(filter, update);
                return result.ModifiedCount == 1 ? Results.NoContent() : Results.NotFound();
            });
        }
        return Validation.RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    #endregion
    
    #region FIELDS
    
    private const string CollectionName = "users";
    
    #endregion
}