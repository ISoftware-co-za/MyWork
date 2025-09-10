import 'package:client_interfaces1/dialog_people/widget/control_person_selected.dart';
import 'package:flutter/material.dart';

import '../../theme/theme_extension_dialog_people.dart';
import '../../theme/theme_extension_text_field.dart';
import '../../ui_toolkit/control_icon_button_reject.dart';
import '../../ui_toolkit/control_text_field.dart';
import '../controller/controller_dialog_people.dart';
import '../controller/list_item_new_person.dart';

class ControlNewPerson extends StatelessWidget {
  ControlNewPerson({
    required ControllerDialogPeople controller,
    required ListItemNewPerson listItem,
    required ThemeExtensionDialogPeople dialogTheme,
    required ThemeExtensionTextField textFieldTheme,
    super.key,
  }) : _controller = controller,
       _person = listItem,
       _dialogTheme = dialogTheme,
       _textThemeField = textFieldTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ControlPersonSelected(controller: _controller, person: _person),
        SizedBox(width: _dialogTheme.dialogBaseTheme.horizontalSpacing),
        Expanded(
          child: ControlTextField(
            hint: "First name",
            property: _person.person.firstName,
            textFieldTheme: _textThemeField,
          ),
        ),
        SizedBox(width: _dialogTheme.dialogBaseTheme.horizontalSpacing),
        Expanded(
          child: ControlTextField(
            hint: "Last name",
            property: _person.person.lastName,
            textFieldTheme: _textThemeField,
          ),
        ),
        SizedBox(
          width: _dialogTheme.commandColumnWidth,
          child: Center(
            child: ControlIconButtonReject(
              Icons.close,
              onPressed: () {
                _controller.onRemoveNewPerson(_person);
              },
            ),
          ),
        ),
      ],
    );
  }

  final ControllerDialogPeople _controller;
  final ListItemNewPerson _person;
  final ThemeExtensionDialogPeople _dialogTheme;
  final ThemeExtensionTextField _textThemeField;
}
