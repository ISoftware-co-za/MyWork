import 'package:client_interfaces1/controller/controller_work.dart';
import 'package:client_interfaces1/tabs/page_activities/widget/layout_form_activity.dart';
import 'package:flutter/material.dart';

import '../../../controller/provider_state_application.dart';
import '../../../controller/state_application.dart';
import '../../../theme/theme_extension_control_activity_state_and_what.dart';
import '../../../theme/theme_extension_spacing.dart';
import '../controller/controller_activity.dart';
import '../controller/controller_activity_list.dart';
import 'layout_activity_list_panel.dart';

class LayoutPageActivities extends StatelessWidget {
  const LayoutPageActivities({super.key});

  @override
  Widget build(BuildContext context) {
    StateApplication stateProvider = ProviderStateApplication.of(context)!.state;
    ControllerWork workController = stateProvider.getController<ControllerWork>()!;

    return ValueListenableBuilder(
        valueListenable: workController.selectedWork,
      builder: (context, value, child) {
        if (value == null) {
          return const Center(child: Text('No work is selected. Select work to list and manage its activities.'));
        }

        ThemeData themeData = Theme.of(context);
        ThemeExtensionSpacing spacingTheme = themeData.extension<ThemeExtensionSpacing>()!;
        ThemeExtensionControlActivityStateAndWhat controlActivityStateAndWhatTheme = themeData.extension<ThemeExtensionControlActivityStateAndWhat>()!;

        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 400, child: LayoutActivityListPanel(controller: stateProvider.getController<ControllerActivityList>()!, spacingTheme: spacingTheme)),
            Expanded(child: LayoutFormActivity(controllerActivityList: stateProvider.getController<ControllerActivityList>()!, controllerActivity: stateProvider.getController<ControllerActivity>()!, spacingTheme: spacingTheme, controlActivityStateAndWhatTheme: controlActivityStateAndWhatTheme))
          ],
        );
      }
    );
  }
}
