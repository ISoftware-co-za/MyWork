namespace client_service.Execution;

public interface IObservability
{
    void StartProcess(string description, string category);
    void EndProcess();
}