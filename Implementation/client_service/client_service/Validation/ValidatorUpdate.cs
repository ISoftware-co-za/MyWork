using System.ComponentModel.DataAnnotations;
using System.Diagnostics;
using System.Text.Json;

namespace ClientService.Validation;

public class ValidatorUpdate(ValidatedPropertyCollection properties) : IValidator
{
    #region METHODS
    
    public ValidationResult[] Validate(object request)
    {
        var updateProperties = request as EntityProperty[];
        Debug.Assert(updateProperties != null, "Update properties is null.");
        var results = new List<ValidationResult>();
        foreach (var property in updateProperties)
        {
            var validationAttributes = properties.GetValidationAttributes(property.NameInPascalCase());
            if (validationAttributes != null)
            {
                var context = new ValidationContext(property) { MemberName = property.Name };
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