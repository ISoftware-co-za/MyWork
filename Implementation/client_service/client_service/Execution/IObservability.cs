namespace ClientService.Execution;

public interface IObservability
{
    void StartProcess(string description, string category);
    void EndProcess();
    
    void EndProcess(Exception exception);
}