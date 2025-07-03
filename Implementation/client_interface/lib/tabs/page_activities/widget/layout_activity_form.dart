import 'package:flutter/material.dart';

import '../controller/controller_activity.dart';
import 'control_activity_state_and_what.dart';

class LayoutActivityForm extends StatefulWidget {
  const LayoutActivityForm({required ControllerActivity controller, super.key}) : _controller = controller;

  @override
  State<LayoutActivityForm> createState() => _LayoutActivityFormState();

  final ControllerActivity _controller;
}

class _LayoutActivityFormState extends State<LayoutActivityForm> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._controller.selectedActivity,
      builder: (context, _) {
        if (widget._controller.selectedActivity.value == null) {
          return const Center(child: Text('No activity selected'));
        }
        return MouseRegion(
          onEnter: (event) {
            setState(() {
              _isMouseover = true;
            });
          },
          onExit: (event) {
            setState(() {
              _isMouseover = false;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ControlActivityStateAndWhat(
                activity: widget._controller.selectedActivity.value!,
                isMouseover: _isMouseover,
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isMouseover = false;
}
