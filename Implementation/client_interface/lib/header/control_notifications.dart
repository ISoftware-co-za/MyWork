import 'package:flutter/material.dart';

class ControlNotifications extends StatelessWidget {
  const ControlNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 40,
        padding: const EdgeInsets.all(2),
        icon: Icon(Icons.notifications, color:  Theme.of(context).appBarTheme.iconTheme!.color),
        onPressed: () {debugPrint('onNotificationsPressed');});
  }
}
