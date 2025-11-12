namespace ClientService;

public class ResultBase(bool? success, string? failureMessage)
{
    public bool? Success { get; set; } = success;
    public string? FailureMessage { get; set; } = failureMessage;

    public void CountSuccessAndFailure(SuccessAndFailureCount successAndFailureCount)
    {
        if (Success == null || Success.Value == false)
            successAndFailureCount.FailureCount += 1;
        else
            successAndFailureCount.SuccessCount += 1;
    }
}

public class ChangeEntityResponse(ResultBase? result, ChildEntityTypeInResponse[]? childUpdateResults)
{
    public ResultBase? Result { get; init; } = result;
    public ChildEntityTypeInResponse[]? ChildUpdateResults { get; init; } = childUpdateResults;
    
    public int GetStatusCode()
    {
        var resultCounts = new SuccessAndFailureCount();
        if (Result != null)
            Result!.CountSuccessAndFailure(resultCounts);
        foreach (ChildEntityTypeInResponse childEntityTypeInResponse in ChildUpdateResults ?? Array.Empty<ChildEntityTypeInResponse>())
            childEntityTypeInResponse.CountSuccessAndFailure(resultCounts);
        if (resultCounts.SuccessCount == 0)
            return 500;
        return 207;
    }
}

public class ChildEntityTypeInResponse(string createTypeName, CreateChildResult[]? createResults, ChangeChildResult[]? updateResults, ChangeChildResult[]? deleteResults) 
{
    public string CreateTypeName { get; init; } = createTypeName;
    public CreateChildResult[]? CreateResults { get; init; } = createResults;
    public ChangeChildResult[]? UpdateResults { get; init; } = updateResults;
    public ChangeChildResult[]? DeleteResults { get; init; } = deleteResults;

    public void CountSuccessAndFailure(SuccessAndFailureCount? successAndFailureCount)
    {
        foreach (CreateChildResult createResult in CreateResults ?? Array.Empty<CreateChildResult>())
            createResult.CountSuccessAndFailure(successAndFailureCount!);
        foreach (ChangeChildResult updateResult in UpdateResults ?? Array.Empty<ChangeChildResult>())
            updateResult.CountSuccessAndFailure(successAndFailureCount!);
        foreach (ChangeChildResult deleteResult in DeleteResults ?? Array.Empty<ChangeChildResult>())
            deleteResult.CountSuccessAndFailure(successAndFailureCount!);
    }
}

public class ChangeChildResult(bool? success, string? failureMessage) : ResultBase(success, failureMessage)
{
}

public class CreateChildResult(bool? success, string? failureMessage, string? id) : ResultBase(success, failureMessage)
{
    public string? Id { get; set; } = id;
}

public class SuccessAndFailureCount
{
    public int SuccessCount { get; set; } = 0;
    public int FailureCount { get; set; } = 0;
}