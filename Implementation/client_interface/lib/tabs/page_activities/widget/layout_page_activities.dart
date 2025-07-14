import 'package:client_interfaces1/controller/controller_work.dart';
import 'package:client_interfaces1/tabs/page_activities/widget/layout_activity_form.dart';
import 'package:flutter/material.dart';

import '../../../controller/provider_state_application.dart';
import '../controller/controller_activity.dart';
import '../controller/controller_activity_list.dart';
import 'layout_activity_list_panel.dart';

class LayoutPageActivities extends StatelessWidget {
  const LayoutPageActivities({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderStateApplication stateProvider = ProviderStateApplication.of(context)!;
    ControllerWork workController = stateProvider.getController<ControllerWork>()!;

    return ValueListenableBuilder(
        valueListenable: workController.selectedWork,
      builder: (context, value, child) {
        if (value == null) {
          return const Center(child: Text('No work is selected. Select work to list and manage its activities.'));
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: 400, child: LayoutActivityListPanel(controller: stateProvider.getController<ControllerActivityList>()!)),
            Expanded(child: LayoutActivityForm(controllerActivityList: stateProvider.getController<ControllerActivityList>()!, controllerActivity: stateProvider.getController<ControllerActivity>()!))
          ],
        );
      }
    );
  }
}
