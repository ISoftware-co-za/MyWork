import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../state/provider_state_application.dart';
import 'controller_notifications.dart';
import 'notifications.dart';

class CommandExecutor {
  static Future<void> execute( Future<void> Function() command, BuildContext context) async {
    try {
      await command();
    } catch (e, stackTrace) {
      if (context.mounted) {
        var frames = stackTrace.toString().split('\n');
        if (frames.length > 2) {
          var callerFrame = frames[2];
          var callerInfo = callerFrame.split(' ').last;
        }
        String message = e.toString().replaceFirst('Exception: ', '');
        ProviderStateApplication provider = ProviderStateApplication.of(context)!;
        ControllerNotifications controller = provider.notificationController;

        if (e is SocketException) {
          message = 'An error occurred while trying to connect to the service. Please check your internet connection.';
        }
        controller.add(NotificationError(message));
      }
    }
  }
}