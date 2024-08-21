import 'package:flutter/material.dart';

import '../state/controller_work.dart';
import '../state/provider_state_application.dart';

class ControlButtonAddWork extends StatelessWidget {
  const ControlButtonAddWork({super.key});

  @override
  Widget build(BuildContext context) {
    IconThemeData iconThemeData = Theme.of(context).appBarTheme.iconTheme!;
    return IconButton(
        iconSize: iconThemeData.size,
        padding: const EdgeInsets.all(2),
        icon: Icon(Icons.add_circle, color: iconThemeData.color),
        onPressed: () {
          ControllerWork workController =
              ProviderStateApplication.of(context)!.workController;
          workController.newWork();
        });
  }
}
