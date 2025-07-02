using System.ComponentModel.DataAnnotations;

namespace ClientService.Validation;

public class ValidatorCreate(ValidatedPropertyCollection properties) : IValidator
{
    public ValidationResult[] Validate(object request)
    {
        var results = new List<ValidationResult>();
        foreach (var property in request.GetType().GetProperties())
        {
            ValidationAttribute[]? validationAttributes = properties.GetValidationAttributes(property.Name);
            if (validationAttributes != null)
            {
                var context = new ValidationContext(request) { MemberName = property.Name };
                var value = property.GetValue(request);
                Validator.TryValidateValue(value, context, results, validationAttributes);
            }
        }
        return results.ToArray();
    }
}