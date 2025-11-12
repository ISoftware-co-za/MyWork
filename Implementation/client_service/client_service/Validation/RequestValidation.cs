using System.ComponentModel.DataAnnotations;
using System.Diagnostics;

namespace ClientService.Validation;

public class RequestValidation
{
    #region METHODS
    
    public void Validate(object request, string createRequestName, bool update, List<ValidationResult> validationResults)
    {
        var validator = GetValidatorForRequest(createRequestName, update);
        ValidationResult[] results = validator.Validate(request);
        validationResults.AddRange(results);
    }

    public void RegisterValidation(ValidatedRequest request)
    {
        _validationRequests.Add(request);
    }
    
    public static IResult GenerateValidationFailedResponse(List<ValidationResult> validationResults)
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
    
    public IValidator GetValidatorForRequest(string createTypeName, bool update = false)
    {
        var requestValidation = _validationRequests.FirstOrDefault(x => x.CreateTypeNameRequestName == createTypeName);
        Debug.Assert(requestValidation != null, $"IValidator for request with type name {createTypeName} is not found.");
        if (!update)
            return new ValidatorCreate(requestValidation!.Properties);
        return new ValidatorUpdate(requestValidation!.Properties);
    }
    
    #endregion
   
    #region FIELDS

    private readonly List<ValidatedRequest> _validationRequests = new();
    
    #endregion
}