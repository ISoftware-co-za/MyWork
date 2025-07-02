namespace ClientService.Execution;

public interface IObservabilityFactory
{
    IObservability Produce();
}