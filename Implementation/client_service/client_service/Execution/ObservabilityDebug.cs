using System.Diagnostics;

namespace ClientService.Execution;

public class ObservabilityDebug : IObservability 
{
    public void StartProcess(string description, string category)
    {
        Debug.WriteLine($"--- START [{category}] {description}");
        _stopwatch.Start();
    }

    public void EndProcess()
    {
        var duration = "";
        if (_stopwatch.IsRunning)
            duration = _stopwatch.ElapsedMilliseconds.ToString();
        Debug.WriteLine($"--- END {duration}");
    }

    public void EndProcess(Exception exception)
    {
        Debug.WriteLine(exception.ToString());
        Debug.WriteLine($"--- END");
    }
    
    Stopwatch _stopwatch = new Stopwatch();
}