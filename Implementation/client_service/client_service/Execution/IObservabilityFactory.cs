namespace client_service.Execution;

public interface IObservabilityFactory
{
    IObservability Produce();
}