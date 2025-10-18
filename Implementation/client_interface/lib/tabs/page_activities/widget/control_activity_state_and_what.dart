import 'package:client_interfaces1/model/activity.dart';
import 'package:flutter/material.dart';

import '../../../execution/executor.dart';
import '../../../theme/theme_extension_control_activity_state_and_what.dart';
import '../../../theme/theme_extension_spacing.dart';
import '../../../ui_toolkit/activity_status_colors.dart';
import '../../../ui_toolkit/form/form.dart';
import '../controller/controller_activity.dart';

class ControlActivityStateAndWhat extends StatefulWidget {
  const ControlActivityStateAndWhat({
    required Activity activity,
    required bool isMouseover,
    required ThemeExtensionSpacing spacingTheme,
    required ThemeExtensionControlActivityStateAndWhat controlActivityStateAndWhatTheme,
    super.key,
  }) : _activity = activity,
       _isMouseover = isMouseover,
        _spacingTheme = spacingTheme,
        _controlActivityStateAndWhatTheme = controlActivityStateAndWhatTheme;

  @override
  State<ControlActivityStateAndWhat> createState() =>
      _ControlActivityStateAndWhatState();

  final Activity _activity;
  final bool _isMouseover;
  final ThemeExtensionSpacing _spacingTheme;
  final ThemeExtensionControlActivityStateAndWhat _controlActivityStateAndWhatTheme;
}

class _ControlActivityStateAndWhatState
    extends State<ControlActivityStateAndWhat> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: widget._spacingTheme.verticalSpacing,
      mainAxisSize: MainAxisSize.max,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.black),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
              ),
            ),
          ),
          child: ListenableBuilder(
            listenable: widget._activity.state,
            builder: (context, child) {
              return DropdownMenu<ActivityState>(
                dropdownMenuEntries:
                    ControllerActivity.getActivityStateDropdownItems(),
                initialSelection: widget._activity.state.value,
                onSelected: (value) {
                  if (value != null) {
                    Executor.runCommand(
                      'ControlActivityStateAndWhat',
                      'PageActivities',
                      () => setState(() {
                        widget._activity.state.value = value;
                      }),
                    );
                  }
                },
                width: widget._controlActivityStateAndWhatTheme.stateWidth,
                textStyle: widget._controlActivityStateAndWhatTheme.stateTextStyle,
                inputDecorationTheme: InputDecorationTheme(
                  constraints: widget._controlActivityStateAndWhatTheme.stateHeightConstraints,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none, // no border
                  ),
                  contentPadding: widget._controlActivityStateAndWhatTheme.contentPadding,
                  filled: true,
                  fillColor: ActivityStatusColors.getColorForState(
                    widget._activity.state.value,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ControlFormFieldEmphasised(
            label: 'What',
            property: widget._activity.what,
            editable: widget._isMouseover,
          ),
        ),
      ],
    );
  }
}
