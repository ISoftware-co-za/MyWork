import 'package:client_interfaces1/ui_toolkit/form/form.dart';
import 'package:flutter/material.dart';

import '../../../model/activity.dart';
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

        final Activity activity = widget._controller.selectedActivity.value!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: MouseRegion(
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
                  activity: activity,
                  isMouseover: _isMouseover,
                ),
                const SizedBox(height: 16),
                ControlDateFormField(label: 'Due date', property: activity.dueDate, editable: _isMouseover),
                const SizedBox(height: 16),
                ControlFormField(label: 'Why', property: activity.why, editable: _isMouseover, maximumLines: 3),
                const SizedBox(height: 16),
                ControlFormField(label: 'Notes', property: activity.notes, editable: _isMouseover, maximumLines: 3),
                const SizedBox(height: 16)
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isMouseover = false;
}
