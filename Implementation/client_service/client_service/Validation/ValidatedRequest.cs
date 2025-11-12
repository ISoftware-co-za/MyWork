namespace ClientService.Validation;

public class ValidatedRequest(string createTypeName, ValidatedPropertyCollection properties)
{
    #region PROPERTIES
    
    public string CreateTypeNameRequestName { get; } = createTypeName;
    public ValidatedPropertyCollection Properties { get; } = properties;
    
    #endregion
}