import 'package:flutter/material.dart';

import '../../../execution/executor.dart';
import '../../../ui_toolkit/control_icon_button_large.dart';
import '../controller/controller_activity_list.dart';

class ControlAddActivity extends StatelessWidget {
  const ControlAddActivity({required ControllerActivityList controller, super.key}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Activities', style: TextStyle(color: Colors.white)),
        const SizedBox(width: 8),
        ControlIconButtonLarge(
            icon: const Icon(Icons.add),
            onPressed: () => Executor.runCommand(
                  'AddActivity',
                  null,
                  () => _controller.onNewActivity())),
      ],
    );
  }

  final ControllerActivityList _controller;
}
