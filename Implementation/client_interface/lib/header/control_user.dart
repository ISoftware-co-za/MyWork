import 'package:flutter/material.dart';

import '../ui_toolkit/icon_button_large.dart';

class ControlUser extends StatelessWidget {
  const ControlUser({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButtonLarge(
        icon: Icon(Icons.person),
        onPressed: () {debugPrint('onUserPressed');});
  }
}
