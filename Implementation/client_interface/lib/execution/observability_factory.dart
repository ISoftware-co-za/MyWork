import 'observability.dart';
import 'observability_debug.dart';

class ObservabilityFactory {
  Observability createObservability() {
    return ObservabilityDebug();
  }
}