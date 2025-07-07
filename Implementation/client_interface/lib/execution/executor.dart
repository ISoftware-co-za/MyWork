import 'dart:async';
import 'dart:io';

import 'package:client_interfaces1/execution/observability.dart';
import 'package:client_interfaces1/execution/ui_container_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../notification/controller_notifications.dart';
import '../notification/notifications.dart';
import 'observability_factory.dart';

class Executor {
  static UIContainerContext uiContext = UIContainerContext();
  static ObservabilityFactory observabilityFactory = ObservabilityFactory();
  static ControllerNotifications? notificationController;

  //#region METHODS

  static void runCommand(
    String control,
    String? pageName,
    void Function() command
  ) {
    final transactionName =
        '${pageName ?? uiContext.currentContainer}.$control';
    var observability = observabilityFactory.createObservability();
    observability.startTransaction(
      transactionName,
      Observability.categoryCommand,
    );

    try {
      command();
    } catch (e, stackTrace) {
      _processException(e, stackTrace, observability);
    } finally {
      observability.endTransaction();
    }
  }

  static Future<void> runCommandAsync(
    String control,
    String? pageName,
    Future<void> Function() command) async {
    final transactionName =
        '${pageName ?? uiContext.currentContainer}.$control';
    var observability = observabilityFactory.createObservability();
    observability.startTransaction(
      transactionName,
      Observability.categoryCommand,
    );

    try {
      await command();
    } catch (e, stackTrace) {
      _processException(
        e,
        stackTrace,
        observability
      );
    } finally {
      observability.endTransaction();
    }
  }

  //#endregion

  //#region PRIVATE METHODS

  static void _processException(
    Object e,
    StackTrace stackTrace,
    Observability observability) {
    debugPrint('Exception occurred: $e');
    debugPrint(stackTrace.toString());

    observability.logException(e, stackTrace);
    String message = e.toString().replaceFirst('Exception: ', '');
    message = _convertToUserFriendlyError(e, message);
    observability.logErrorMessage(message);
    notificationController!.add(NotificationError(message));
  }

  static String _convertToUserFriendlyError(Object e, String message) {
    if (e is SocketException || e is HttpException || e is ClientException) {
      message =
          'The application communicates with a server. Unable to connect to the server. Please check your internet connection or try again later.';
    } else if (e is TimeoutException) {
      message =
          'The application communicates with a server. This server is not responding. Please check your internet connection or try again later.';
    } else if (e is TypeError) {
      message =
          'A technical error occurred. Our engineers are looking into the error. Please try again a little later';
    }
    return message;
  }

  //#endregion
}
