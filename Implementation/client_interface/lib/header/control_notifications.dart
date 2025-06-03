import 'package:flutter/material.dart';

import '../ui_toolkit/icon_button_large.dart';

class ControlNotifications extends StatelessWidget {
  const ControlNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButtonLarge(
        icon: Icon(Icons.notifications),
        onPressed: () {debugPrint('onNotificationsPressed');});
  }
}
