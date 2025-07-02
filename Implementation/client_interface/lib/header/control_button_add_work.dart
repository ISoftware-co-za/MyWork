import 'package:flutter/material.dart';

import '../controller/controller_work.dart';
import '../controller/provider_state_application.dart';
import '../ui_toolkit/control_icon_button_large.dart';

class ControlButtonAddWork extends StatelessWidget {
  const ControlButtonAddWork({super.key});

  @override
  Widget build(BuildContext context) {
    return ControlIconButtonLarge(
        icon: Icon(Icons.add),
        onPressed: () async {
            ControllerWork workController = ProviderStateApplication.of(context)!.getController<ControllerWork>()!;
            await workController.onNewWork();
        });
  }
}
