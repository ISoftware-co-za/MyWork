import 'dart:io';

import 'package:client_interfaces1/execution/observability.dart';
import 'package:client_interfaces1/execution/observability_sentry.dart';
import 'package:client_interfaces1/execution/ui_container_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../state/provider_state_application.dart';
import '../notification/controller_notifications.dart';
import '../notification/notifications.dart';


class Executor {

  static UIContainerContext uiContext = UIContainerContext();
  static Observability observability = ObservabilitySentry();

  static Future<void> runCommand(String control, String? pageName, Future<void> Function() command, BuildContext context) async {
    final transactionName = '${pageName ?? uiContext.currentContainer}.$control';
    observability.startTransaction(transactionName, Observability.categoryCommand);

    try {
      await command();
    } catch (e) {

      if (e is Exception) {
        observability.logException(e);
      }
      String message = e.toString().replaceFirst('Exception: ', '');
      if (e is SocketException || e is HttpException || e is ClientException) {
        message =
        'An error occurred while trying to connect to the service. Please check your internet connection.';
      }
      observability.logErrorMessage(message);

      if (context.mounted) {
        ProviderStateApplication provider = ProviderStateApplication.of(
            context)!;
        ControllerNotifications notificationController = provider
            .notificationController;
        notificationController.add(NotificationError(message));
      }
    }  finally {
      observability.endTransaction();
    }
  }
}