using System.ComponentModel.DataAnnotations;

namespace ClientService.Validation;

public interface IValidator
{
    ValidationResult[] Validate(object request);
} 
