import 'package:flutter/material.dart';

import '../state/provider_state_application.dart';
import 'controller_notifications.dart';
import 'notifications.dart';

//----------------------------------------------------------------------------------------------------------------------

class ControlNotificationError extends StatefulWidget {
  final NotificationError notification;
  const ControlNotificationError({required this.notification, super.key});

  @override
  State<ControlNotificationError> createState() => _ControlNotificationErrorState();
}

class _ControlNotificationErrorState extends State<ControlNotificationError> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Icon(Icons.error),
          const SizedBox(width: 10),
          Expanded(child: Text(widget.notification.text)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                ControllerNotifications controller = ProviderStateApplication.of(context)!.notificationController;
                controller.remove(widget.notification);
              });
            },
          ),
        ],
      ),
    );
  }
}