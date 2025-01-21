using System.ComponentModel.DataAnnotations;

namespace client_service.Validation;

public class RequiredNonWhitespaceAttribute : ValidationAttribute
{
    protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
    {
        if (value is string str && string.IsNullOrWhiteSpace(str))
            return new ValidationResult($"{validationContext.DisplayName} cannot be empty or contain only whitespace.");
        return ValidationResult.Success;
    }
}