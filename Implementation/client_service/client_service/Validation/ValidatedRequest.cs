namespace ClientService.Validation;

public class ValidatedRequest(Type? create, Type? update, ValidatedPropertyCollection properties)
{
    #region PROPERTIES
    
    public Type? Create { get; } = create;
    public Type? Update { get; } = update;
    public ValidatedPropertyCollection Properties { get; } = properties;
    
    #endregion
}