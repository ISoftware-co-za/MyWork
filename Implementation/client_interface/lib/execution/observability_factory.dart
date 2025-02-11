import 'observability.dart';
import 'observability_sentry.dart';

class ObservabilityFactory {
  Observability createObservability() {
    return ObservabilitySentry();
  }
}