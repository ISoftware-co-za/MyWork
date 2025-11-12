import 'package:client_interfaces1/tabs/page_activities/widget/Layout_notes.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme_extension_control_activity_state_and_what.dart';
import '../../../theme/theme_extension_spacing.dart';
import '../controller/controller_activity.dart';
import '../controller/controller_activity_list.dart';
import 'layout_activity_details.dart';

class LayoutFormActivity extends StatelessWidget {
  const LayoutFormActivity({
    required ControllerActivityList controllerActivityList,
    required ControllerActivity controllerActivity,
    required ThemeExtensionSpacing spacingTheme,
    required ThemeExtensionControlActivityStateAndWhat
    controlActivityStateAndWhatTheme,
    super.key,
  }) : _controllerActivityList = controllerActivityList,
       _controllerActivity = controllerActivity,
       _spacingTheme = spacingTheme,
       _controlActivityStateAndWhatTheme = controlActivityStateAndWhatTheme;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controllerActivity.selectedActivity,
      builder: (context, _) {
        if (_controllerActivity.selectedActivity.value == null) {
          return Center(child: Text('No activity selected'));
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                LayoutActivityDetails(
                  controllerActivityList: _controllerActivityList,
                  controllerActivity: _controllerActivity,
                  spacingTheme: _spacingTheme,
                  controlActivityStateAndWhatTheme:
                  _controlActivityStateAndWhatTheme,
                ),
                LayoutActivityNotes(controller: _controllerActivity, spacingTheme: _spacingTheme)
              ],
            ),
          );
        }
      },
    );
  }

  final ControllerActivityList _controllerActivityList;
  final ControllerActivity _controllerActivity;
  final ThemeExtensionSpacing _spacingTheme;
  final ThemeExtensionControlActivityStateAndWhat
  _controlActivityStateAndWhatTheme;
}
