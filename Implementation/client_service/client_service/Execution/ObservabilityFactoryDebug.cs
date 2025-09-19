namespace ClientService.Execution;

public class ObservabilityFactoryDebug : IObservabilityFactory
{
    public IObservability Produce()
    {
        return new ObservabilityDebug();
    }
}
