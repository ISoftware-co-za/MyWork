using System.Diagnostics;

namespace client_service.Execution;

public class ObservabilitySentry : IObservability
{
    #region METHODS
    
    public void StartProcess(string description, string category)
    {
        if (_currentSpan != null)
            _currentSpan!.Finish();
        _currentSpan = SentrySdk.GetSpan()?.StartChild(category, description: description);
    }

    public void EndProcess()
    {
        Debug.Assert(_currentSpan != null, "ObservabilitySentry.StartProcess should be called before calling ObservabilitySentry.EndProcess");
        _currentSpan!.Finish();
        _currentSpan = null;
    }

    public void EndProcess(Exception exception)
    {
        SentrySdk.CaptureException(exception);
    }

    #endregion

    #region FIELDS

    private ISpan? _currentSpan;
    
    #endregion
}