using Microsoft.AspNetCore.Mvc;

namespace ClientService.Execution;

public static class Executor
{
    #region CONSTANTS
    
    public const string CategoryEndpoint = "Endpoint";
    public const string CategoryMongoDB = "MongoDB";
    
    #endregion
    
    #region PROPERTIES

    private static IObservabilityFactory ObservabilityFactory { get; set; } = new ObservabilityFactoryDebug();
    
    #endregion
    
    #region METHODS

    public static async Task<IResult> RunProcessAsync(string description, string category, string errorMessage, Func<Task<IResult>> asyncProcess )
    {
        IObservability observability = ObservabilityFactory.Produce();
        try
        {
            observability?.StartProcess(description, category);
            var result = await asyncProcess();
            observability?.EndProcess();
            return result;
        }
        catch (Exception exception)
        {
            observability.EndProcess(exception);
            var problemDetails = new ProblemDetails
            {
                Status = StatusCodes.Status500InternalServerError,
                Title = "An unexpected error occurred",
                Detail = $"{errorMessage} We are looking into the error.",
            };  
            return Results.Problem(problemDetails);
        }
    }
    
    #endregion
}