import 'package:client_interfaces1/service/service_client.dart';
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
        onPressed: () async {
          ControllerWork workController =
              ProviderStateApplication.of(context)!.workController;
          workController.newWork();

          try
          {
            var work = WorkCreateRequest(name: "Work name", type: "Incident", reference: "INC123456789");
            var client = ServiceClient("https://localhost:5000");
            var response = await client.workCreate(work);
            debugPrint("Work created with id: ${response.id}");
          }
          catch (e)
          {
            debugPrint(e.toString());
          }

        });
  }
}
