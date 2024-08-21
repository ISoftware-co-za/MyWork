import 'package:flutter/material.dart';

class ControlUser extends StatelessWidget {
  const ControlUser({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 40,
        padding: const EdgeInsets.all(2),
        icon: Icon(Icons.person, color: Theme.of(context).appBarTheme.iconTheme!.color),
        onPressed: () {debugPrint('onUserPressed');});
  }
}
