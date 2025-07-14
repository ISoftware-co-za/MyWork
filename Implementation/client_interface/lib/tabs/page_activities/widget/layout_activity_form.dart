import 'package:client_interfaces1/ui_toolkit/form/form.dart';
import 'package:flutter/material.dart';

import '../../../model/activity.dart';
import '../../../ui_toolkit/control_delete.dart';
import '../controller/controller_activity.dart';
import '../controller/controller_activity_list.dart';
import 'control_activity_state_and_what.dart';

class LayoutActivityForm extends StatefulWidget {
  const LayoutActivityForm({required ControllerActivityList controllerActivityList, required ControllerActivity controllerActivity, super.key}) : _controllerActivityList = controllerActivityList, _controllerActivity = controllerActivity;

  @override
  State<LayoutActivityForm> createState() => _LayoutActivityFormState();

  final ControllerActivityList _controllerActivityList;
  final ControllerActivity _controllerActivity;
}

class _LayoutActivityFormState extends State<LayoutActivityForm> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._controllerActivity.selectedActivity,
      builder: (context, _) {
        if (widget._controllerActivity.selectedActivity.value == null) {
          return const Center(child: Text('No activity selected'));
        }

        final Activity activity = widget._controllerActivity.selectedActivity.value!;
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
                const SizedBox(height: 16),
                if (_isMouseover && !activity.isNew)
                  Center(
                    child: ControlDelete(
                      pageName: 'LayoutActivityForm',
                      onDelete: () async {
                        await widget._controllerActivityList.onDeleteActivity();
                      }
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isMouseover = false;
}
