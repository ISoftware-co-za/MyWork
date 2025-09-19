import 'package:flutter/material.dart';

import '../../model/person.dart';
import '../../theme/theme_extension_dialog_people.dart';
import '../controller/controller_dialog_people.dart';

class ControlPersonSelected extends StatelessWidget {
  ControlPersonSelected({
    required ControllerDialogPeople controller,
    required Person person,
    required ThemeExtensionDialogPeople dialogTheme,
    super.key,
  }) : _controller = controller,
       _person = person,
        _dialogTheme = dialogTheme {
    debugPrint('ControlPersonSelected ${_person.firstName.value} ${_person.lastName.value}');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _controller.selectedPerson,
        builder: (context, value, child) {
          debugPrint('_ControlPersonSelectedState.build ${_person.firstName.value} ${_person.lastName.value}. Checked = ${_controller.selectedPerson.value == _person}');
          return SizedBox(
              width: _dialogTheme.selectionColumnWidth,
              child: Radio<Person>(value: _person, groupRegistry: _controller.selectedPersonRegistry)
          );
        }
    );
  }

  final ControllerDialogPeople _controller;
  final ThemeExtensionDialogPeople _dialogTheme;
  final Person _person;
}

