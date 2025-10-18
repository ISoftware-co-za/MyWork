import 'package:flutter/foundation.dart';

import 'observability.dart';

class ObservabilityDebug implements Observability {

  @override
  void startTransaction(String transactionName, String category) {
    debugPrint('--- START [$category] $transactionName');
  }

  @override
  void setTransactionData(String name, dynamic value) {
    debugPrint('| DATA $name = $value');
  }

  @override
  void startServiceCall(Map<String, String> headers) {
    debugPrint('ServiceCall');
  }

  @override
  void endTransaction() {
    debugPrint('--- END');
  }

  @override
  void logErrorMessage(String message) {
    debugPrint('--- ERROR $message');
  }

  @override
  void logException(Object error, StackTrace stackTrace) {
    debugPrint('--- ERROR ---');
    debugPrint(error.toString());
    debugPrint(stackTrace.toString() );
  }
}