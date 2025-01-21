using System.ComponentModel.DataAnnotations;
using System.Diagnostics;

namespace client_service.Validation;

public class Validation
{
    #region METHODS
    
    public ValidationResult[] Validate(object request)
    {
        var validator = GetValidatorForRequest(request.GetType())!;
        return validator.Validate(request);
    }

    public void RegisterValidation(ValidatedRequest request)
    {
        _validationRequests.Add(request);
    }
    
    public static IResult GenerateValidationFailedResponse(ValidationResult[] validationResults)
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
    
    #region PRIVATE METHODS

    private IValidator GetValidatorForRequest(Type type)
    {
        var requestValidation = _validationRequests.FirstOrDefault(x => x.Create == type || x.Update == type);
        Debug.Assert(requestValidation != null, $"IValidator for request with type {type.Name} is not found.");
        if (requestValidation.Create == type)
            return new ValidatorCreate(requestValidation!.Properties);
        if (requestValidation.Update == type)
            return new ValidatorUpdate(requestValidation!.Properties);
        throw new Exception($"IValidator for request with type {type.Name} is not found.");
    }
    
    #endregion
    
    #region FIELDS

    private readonly List<ValidatedRequest> _validationRequests = new();
    
    #endregion
}