using System.ComponentModel.DataAnnotations;
using System.Diagnostics;
using System.Text.Json;

namespace client_service.Validation;

public class ValidatorUpdate(ValidatedPropertyCollection properties) : IValidator
{
    #region METHODS
    
    public ValidationResult[] Validate(object request)
    {
        var updateRequest = request as IUpdateRequest;
        Debug.Assert(updateRequest != null);
        var results = new List<ValidationResult>();
        foreach (var property in updateRequest.UpdatedProperties)
        {
            var validationAttributes = properties.GetValidationAttributes(property.Name);
            if (validationAttributes != null)
            {
                var context = new ValidationContext(request) { MemberName = property.Name };
                Validator.TryValidateValue(GetValue(property.Value), context, results, validationAttributes);
            }
        }
        return results.ToArray();
    }
    
    #endregion
    
    #region PRIVATE METHODS

    private object? GetValue(object? value)
    {
        if (value is JsonElement jsonElement)
            return jsonElement.GetString();
        return value;
    }
    
    #endregion
}