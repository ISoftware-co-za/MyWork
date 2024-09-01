import 'package:client_interfaces1/tabs/page_details/layout_details_form.dart';
import 'package:flutter/material.dart';

import '../../state/controller_work.dart';
import '../../state/provider_state_application.dart';
import '../../state/state_work.dart';

//----------------------------------------------------------------------------------------------------------------------

class PageDetails extends StatelessWidget {
  const PageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerWork applicationState = ProviderStateApplication.of(context)!.workController;
    return ValueListenableBuilder(
        valueListenable: applicationState.selectedWork,
        builder: (BuildContext context, StateWork? work, Widget? child) {
          if (applicationState.hasWork) {
            return _generateWorkForm(applicationState.selectedWork.value!);
          } else {
            return _displayNoWork();
          }
        });
  }

  Widget _generateWorkForm(StateWork work) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(16),
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 700),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return LayoutDetailsForm(work: work);
          },
        ),
      ),
    );
  }

  Widget _displayNoWork() {
    return const Center(child: Text('No work selected'));
  }
}
