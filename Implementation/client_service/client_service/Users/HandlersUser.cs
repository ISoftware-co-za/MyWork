using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Bson;
using MongoDB.Driver;

using ClientService.Execution;
using ClientService.Utilities;
using ClientService.Validation;

namespace ClientService.Users;

public static class HandlersUser
{
    #region METHODS
    
    public static void MapUsersURLs(this WebApplication app, string urlPrefix, string corsPolicyName)
    {
        RouteGroupBuilder groupBuilder = app.MapGroup(urlPrefix);
        groupBuilder.MapPost("/login", PostLogin).RequireCors(corsPolicyName);
        groupBuilder.MapPost("/logout", PostLogout).RequireAuthorization("Policy_User").RequireCors(corsPolicyName);
        groupBuilder.MapPost("/workTypes", PostWorkType).RequireAuthorization("Policy_User").RequireCors(corsPolicyName);
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
            nameof(LoginRequest), 
            new ValidatedPropertyCollection(loginRequestProperties.ToArray())
        ));
        
        List<ValidatedProperty> newWorkTypeProperties =
        [
            new ValidatedProperty(nameof(AddWorkTypeRequest.WorkType),
                [new RequiredNonWhitespaceAttribute(), new StringLengthAttribute(maximumLength: 50)]),
        ];
        requestValidation.RegisterValidation(new ValidatedRequest(
            nameof(AddWorkTypeRequest), 
            new ValidatedPropertyCollection(newWorkTypeProperties.ToArray())
        ));
    }
    
    #endregion
    
    #region HTTP HANDLERS
    
    private static async Task<IResult> PostLogin([FromBody] LoginRequest request, [FromServices] RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        var validationResults = new List<ValidationResult>();
        requestValidation.Validate(request, nameof(LoginRequest), false, validationResults);
        if (validationResults.Count == 0)
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
                    await SignInUser(httpRequest.HttpContext, user);
                    var response = new LoginResponse(user.Id.ToString(), user.WorkTypes);
                    return Results.Ok(response);
                }
                return Results.Forbid();
            });
        }
        return RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    private static async Task<IResult> PostLogout([FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        await httpRequest.HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        return Results.Ok();
    }

    private static async Task<IResult> PostWorkType(AddWorkTypeRequest request, [FromServices]  RequestValidation requestValidation, [FromServices] IMongoDatabase database, [FromServices] ILogger<Program> logger, HttpRequest httpRequest)
    {
        var validationResults = new List<ValidationResult>();
        requestValidation.Validate(request, nameof(AddWorkTypeRequest), false, validationResults);
        if (validationResults.Count == 0)
        {
            return await Executor.RunProcessAsync($"{CollectionName}.UpdateOneAsync(filter, update)", Executor.CategoryMongoDB, "Unable to add a work type.", async () =>
            {
                var filter = Builders<DocumentUser>.Filter.Eq("_id", ObjectId.Parse(httpRequest.HttpContext.User.Claims.First(claim => claim.Type == ClaimTypes.Sid).Value));
                var update = Builders<DocumentUser>.Update.AddToSet(u => u.WorkTypes, request.WorkType);
                var result = await database.GetCollection<DocumentUser>(CollectionName).UpdateOneAsync(filter, update);
                return result.ModifiedCount == 1 ? Results.NoContent() : Results.NotFound();
            });
        }
        return Validation.RequestValidation.GenerateValidationFailedResponse(validationResults);
    }
    
    #endregion
    
    #region PRIVATE METHODS
    
    private static async Task SignInUser(HttpContext httpContext, DocumentUser user)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.Email, user.Email),
            new(ClaimTypes.Sid, user.Id.ToString()),
            new(ClaimTypes.Role, "User")
        };
        var claimsIdentity = new ClaimsIdentity(
            claims, CookieAuthenticationDefaults.AuthenticationScheme);
        var authProperties = new AuthenticationProperties
        {
            AllowRefresh = true,
            ExpiresUtc = DateTimeOffset.UtcNow.AddMinutes(10),
            IssuedUtc = DateTimeOffset.Now,
        };
        await httpContext.SignInAsync(
            CookieAuthenticationDefaults.AuthenticationScheme, 
            new ClaimsPrincipal(claimsIdentity), 
            authProperties);
    }
    
    #endregion
    
    #region FIELDS
    
    private const string CollectionName = "users";
    
    #endregion
}