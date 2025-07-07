import 'package:client_interfaces1/model/activity.dart';
import 'package:flutter/material.dart';

import '../../../execution/executor.dart';
import '../../../ui_toolkit/activity_status_colors.dart';
import '../../../ui_toolkit/form/form.dart';
import '../controller/controller_activity.dart';

class ControlActivityStateAndWhat extends StatelessWidget {
  const ControlActivityStateAndWhat({required Activity activity, required bool isMouseover, super.key})
      : _activity = activity,
        _isMouseover = isMouseover;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.max,
      children: [
        DropdownMenu<ActivityState>(
            dropdownMenuEntries: ControllerActivity.getActivityStateDropdownItems(),
            initialSelection: _activity.state.value,
            onSelected: (value) {
              if (value != null) {
                Executor.runCommand('ControlActivityStateAndWhat', 'PageActivities', () => _activity.state.value = value);
              }
            },
            width: 160,
            textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            inputDecorationTheme: InputDecorationTheme(
              constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide.none, // no border
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              filled: true,
              fillColor: ActivityStatusColors.getColorForState(_activity.state.value),
            ),
        ),
        Expanded(
          child: ControlFormFieldEmphasised(
            label: 'What',
            property: _activity.what,
            editable: _isMouseover,
          ),
        ),
      ],
    );
  }

  final Activity _activity;
  final bool _isMouseover;
}
