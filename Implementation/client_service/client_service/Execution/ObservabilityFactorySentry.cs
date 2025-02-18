namespace client_service.Execution;

public class ObservabilityFactorySentry : IObservabilityFactory
{
    public IObservability Produce()
    {
        return new ObservabilitySentry();
    }
}