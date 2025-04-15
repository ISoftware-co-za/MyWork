import 'package:client_interfaces1/tabs/page_details/layout_details_form.dart';
import 'package:flutter/material.dart';

import '../../state/controller_work.dart';
import '../../state/provider_state_application.dart';
import '../../state/state_work.dart';

//----------------------------------------------------------------------------------------------------------------------

class PageDetails extends StatelessWidget {
  PageDetails({super.key}) {}

  @override
  Widget build(BuildContext context) {
    ControllerWork controller =
        ProviderStateApplication.of(context)!.workController;
    return ValueListenableBuilder(
        valueListenable: controller.selectedWork,
        builder: (BuildContext context, StateWork? work, Widget? child) {
          if (controller.hasWork) {
            return _generateWorkForm(controller);
          } else {
            return _displayNoWork();
          }
        });
  }

  Widget _generateWorkForm(ControllerWork controller) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(16),
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 700),
        child: LayoutDetailsForm(controller: controller),
      ),
    );
  }

  Widget _displayNoWork() {
    return const Center(child: Text('No work selected'));
  }
}
