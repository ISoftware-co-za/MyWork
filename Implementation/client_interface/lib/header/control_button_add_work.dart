import 'package:flutter/material.dart';

import '../app/controller_work.dart';
import '../app/provider_state_application.dart';
import '../ui_toolkit/icon_button_large.dart';

class ControlButtonAddWork extends StatelessWidget {
  const ControlButtonAddWork({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButtonLarge(
        icon: Icon(Icons.add),
        onPressed: () async {
            ControllerWork workController = ProviderStateApplication.of(context)!.workController;
            await workController.onNewWork();
        });
  }
}
