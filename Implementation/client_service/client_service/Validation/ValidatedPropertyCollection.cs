using System.ComponentModel.DataAnnotations;
using System.Diagnostics;

namespace ClientService.Validation;

public class ValidatedPropertyCollection
{
    #region CONSTRUCTION
    public ValidatedPropertyCollection(ValidatedProperty[] properties)
    {
        Debug.Assert(properties.Length > 0);
        Properties = properties;
    }
    
    #endregion
    
    #region PROPERTIES

    public ValidatedProperty[] Properties { get; }
    
    #endregion
    
    #region METHODS
    
    public ValidationAttribute[]? GetValidationAttributes(string propertyName)
    {
        return Properties.FirstOrDefault(p => p.Name == propertyName)?.ValidationAttributes;
    }
    
    #endregion
}