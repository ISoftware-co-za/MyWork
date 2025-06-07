import 'package:flutter/material.dart';

import '../ui_toolkit/control_icon_button_large.dart';

class ControlUser extends StatelessWidget {
  const ControlUser({super.key});

  @override
  Widget build(BuildContext context) {
    return ControlIconButtonLarge(
        icon: Icon(Icons.person),
        onPressed: () {debugPrint('onUserPressed');});
  }
}
