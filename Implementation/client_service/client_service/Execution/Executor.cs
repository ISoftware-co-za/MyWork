using Microsoft.AspNetCore.Mvc;

namespace client_service.Execution;

public static class Executor
{
    #region CONSTANTS
    
    public const string CategoryMongoDB = "MongoDB";
    
    #endregion
    
    #region PROPERTIES

    public static IObservability? Observability { get; set; } = new ObservabilitySentry();
    
    #endregion
    
    #region METHODS

    public static async Task<IResult> RunProcessAsync(string description, string category, string errorMessage, Func<Task<IResult>> asyncProcess )
    {
        try
        {
            Observability?.StartProcess(description, category);
            var result = await asyncProcess();
            Observability?.EndProcess();
            return result;
        }
        catch (Exception exception)
        {
            SentrySdk.CaptureException(exception);
            var problemDetails = new ProblemDetails
            {
                Status = StatusCodes.Status500InternalServerError,
                Title = "An unexpected error occurred",
                Detail = $"{errorMessage}. We are looking into the error.",
            };  
            return Results.Problem(problemDetails);
        }
    }
    
    #endregion
}