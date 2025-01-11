abstract class Observability {

  static const String categoryCommand = "command";

  void startTransaction(String transactionName, String category);
  void logException(Exception exception);
  void logErrorMessage(String message);
  void endTransaction();

  void startServiceCall(Map<String,String> headers);
}
