import 'package:flutter/material.dart';

import '../../state/controller_work.dart';
import '../../state/provider_state_application.dart';
import '../../state/state_work.dart';
import '../../ui toolkit/control_form_field.dart';

class PageDetails extends StatelessWidget {
  const PageDetails({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerWork applicationState =
        ProviderStateApplication.of(context)!.workController;
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
    return Column(
      children: <Widget>[
        ControlFormField(label: 'What', property: work.name),
        Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
          debugPrint(textEditingValue.text);
          return <String>[
            textEditingValue.text,
            'Project',
            'Incident',
            'Event',
            'Ad-hoc'
          ];
        }, onSelected: (String selection) {
          debugPrint('You just selected $selection');
        }),
        ControlFormField(label: 'Reference', property: work.reference),
        ControlFormField(label: 'What', property: work.description),
      ],
    );
  }

  Widget _displayNoWork() {
    return const Center(child: Text('No work selected'));
  }
}
