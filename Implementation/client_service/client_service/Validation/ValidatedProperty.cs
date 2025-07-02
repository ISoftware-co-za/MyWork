using System.ComponentModel.DataAnnotations;
using System.Diagnostics;

namespace ClientService.Validation;

public class ValidatedProperty
{
    #region PROPERTIES
    
    public string Name { get; }
    public ValidationAttribute[] ValidationAttributes { get; }
    
    #endregion
    
    #region CONSTRUCTION
    
    public ValidatedProperty(string name, ValidationAttribute[] validationAttributes)
    {
        Debug.Assert(validationAttributes.Length > 0);
        Name = name;
        ValidationAttributes = validationAttributes;
    }
    
    #endregion
}

