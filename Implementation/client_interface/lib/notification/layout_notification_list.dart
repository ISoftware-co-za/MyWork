import 'package:flutter/widgets.dart' hide Notification;

import '../state/provider_state_application.dart';
import 'control_notifications.dart';
import 'notifications.dart';

class LayoutNotifications extends StatefulWidget {
  const LayoutNotifications({super.key});

  @override
  State<LayoutNotifications> createState() => _LayoutNotificationsState();
}

class _LayoutNotificationsState extends State<LayoutNotifications> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: ProviderStateApplication.of(context)!.notificationController,
        builder: (BuildContext context, Widget? child) {
          List<Widget> notifications = _listNotifications(ProviderStateApplication.of(context)!.notificationController.notifications);
          return Column(
            children: notifications,
          );
        });
  }

  List<Widget> _listNotifications(List<Notification> notifications) {
    var list = <Widget>[];

    debugPrint('Displaying notifications: ${notifications.length}');
    for(int index = 0; index < notifications.length; index++) {
      Notification notification = notifications[index];
      if (notification is NotificationError) {
        list.add(ControlNotificationError(notification: notification));
      } else {
        assert(false, 'Unknown notification type: ${notification.runtimeType}');
      }
    }
    return list;
  }
}
