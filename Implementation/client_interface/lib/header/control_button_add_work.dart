import 'package:client_interfaces1/controller/coordinator_work_and_activity_list_loader.dart';
import 'package:flutter/material.dart';

import '../controller/provider_state_application.dart';
import '../ui_toolkit/control_icon_button_large.dart';

class ControlButtonAddWork extends StatelessWidget {
  const ControlButtonAddWork({super.key});

  @override
  Widget build(BuildContext context) {
    return ControlIconButtonLarge(
        icon: Icon(Icons.add),
        onPressed: () async {
            CoordinatorWorkActivityListLoader coordinatorWorkActivityListLoader = ProviderStateApplication.of(context)!.getCoordinator<CoordinatorWorkActivityListLoader>()!;
            await coordinatorWorkActivityListLoader.onNewWork();
        });
  }
}
