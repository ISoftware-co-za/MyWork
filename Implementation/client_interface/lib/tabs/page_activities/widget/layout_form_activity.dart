import 'package:client_interfaces1/dialog_people/controller/controller_dialog_people.dart';
import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/ui_toolkit/form/form.dart';
import 'package:flutter/material.dart';

import '../../../dialog_people/widget/layout_dialog_people.dart';
import '../../../model/activity.dart';
import '../../../ui_toolkit/control_delete.dart';
import '../../../ui_toolkit/control_icon_button.dart';
import '../controller/controller_activity.dart';
import '../controller/controller_activity_list.dart';
import 'control_activity_state_and_what.dart';

class LayoutFormActivity extends StatefulWidget {
  const LayoutFormActivity({
    required ControllerActivityList controllerActivityList,
    required ControllerActivity controllerActivity,
    super.key,
  }) : _controllerActivityList = controllerActivityList,
       _controllerActivity = controllerActivity;

  @override
  State<LayoutFormActivity> createState() => _LayoutFormActivityState();

  final ControllerActivityList _controllerActivityList;
  final ControllerActivity _controllerActivity;
}

class _LayoutFormActivityState extends State<LayoutFormActivity> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._controllerActivity.selectedActivity,
      builder: (context, _) {
        if (widget._controllerActivity.selectedActivity.value == null) {
          return const Center(child: Text('No activity selected'));
        }

        final Activity activity =
            widget._controllerActivity.selectedActivity.value!;
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ControlDateFormField(
                        label: 'Due date',
                        property: activity.dueDate,
                        editable: _isMouseover,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ControlIconButton(
                          Icons.person,
                          onPressed: () => Executor.runCommand(
                            'person',
                            'LayoutActivityForm',
                            () {
                              _showPeopleDialog(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ControlFormField(
                  label: 'Why',
                  property: activity.why,
                  editable: _isMouseover,
                  maximumLines: 3,
                ),
                const SizedBox(height: 16),
                ControlFormField(
                  label: 'Notes',
                  property: activity.notes,
                  editable: _isMouseover,
                  maximumLines: 3,
                ),
                const SizedBox(height: 16),
                if (_isMouseover && !activity.isNew)
                  Center(
                    child: ControlDelete(
                      pageName: 'LayoutActivityForm',
                      onDelete: () async {
                        await widget._controllerActivityList.onDeleteActivity();
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPeopleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutDialogPeople(
          controller: ControllerDialogPeople(context)
        );
      },
    );
  }

  bool _isMouseover = false;
}
