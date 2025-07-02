namespace ClientService.Execution;

public class ObservabilityFactorySentry : IObservabilityFactory
{
    public IObservability Produce()
    {
        return new ObservabilitySentry();
    }
}