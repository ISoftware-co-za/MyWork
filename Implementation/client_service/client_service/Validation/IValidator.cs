using System.ComponentModel.DataAnnotations;

namespace client_service.Validation;

public interface IValidator
{
    ValidationResult[] Validate(object request);
} 