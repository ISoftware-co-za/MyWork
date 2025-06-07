import 'package:flutter/material.dart';

import '../ui_toolkit/control_icon_button_large.dart';

class ControlNotifications extends StatelessWidget {
  const ControlNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return ControlIconButtonLarge(
        icon: Icon(Icons.notifications),
        onPressed: () {debugPrint('onNotificationsPressed');});
  }
}
