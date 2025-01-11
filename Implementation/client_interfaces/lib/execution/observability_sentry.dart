import 'package:client_interfaces1/execution/observability.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ObservabilitySentry implements Observability {

  //#region METHODS

  @override
  void startTransaction(String transactionName, String category) {
    _finishTransaction();
    _currentTransaction = Sentry.startTransaction(transactionName, category, bindToScope: true);
  }

  @override
  void logException(Exception exception) {
    Sentry.captureException(exception);
  }

  @override
  void logErrorMessage(String message) {
    assert(_currentTransaction != null, 'No transaction started. Please call ObservabilitySentry.startTransaction before calling ObservabilitySentry.logErrorMessage');
    _currentTransaction!.setData('error.message', message);
  }

  @override
  void endTransaction() {
    assert(_currentTransaction != null, 'No transaction started. Please call ObservabilitySentry.startTransaction before calling ObservabilitySentry.endTransaction');
    _finishTransaction();
  }

  @override
  void startServiceCall(Map<String, String> headers) {
    final span = Sentry.getSpan();
    final traceHeader = span?.toSentryTrace();
    final baggageHeader = span?.toBaggageHeader();
    headers[traceHeader!.name] = traceHeader.value;
    headers[baggageHeader!.name] = baggageHeader.value;
  }

  //#endregion

  //#region PRIVATE METHODS

  void _finishTransaction() {
    if (_currentTransaction != null) {
      _currentTransaction!.finish();
      _currentTransaction = null;
    }
  }

  //#endregion

  //#region FIELDS

  ISentrySpan? _currentTransaction;

  //#endregion
}