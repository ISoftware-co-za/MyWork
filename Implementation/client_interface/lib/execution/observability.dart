abstract class Observability {

  static const String categoryCommand = "command";

  void startTransaction(String transactionName, String category);
  void logException(Object error, StackTrace stackTrace);
  void logErrorMessage(String message);
  void endTransaction();

  void startServiceCall(Map<String,String> headers);
}
