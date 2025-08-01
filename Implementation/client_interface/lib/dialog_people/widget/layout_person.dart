import 'package:client_interfaces1/dialog_people/controller/controller_dialog_people.dart';
import 'package:client_interfaces1/ui_toolkit/form/form.dart';
import 'package:flutter/material.dart';

import '../../theme/theme_extension_dialog_people.dart';
import '../controller/list_item_person.dart';
import 'control_person_command.dart';
import 'control_person_selected.dart';

class LayoutPerson extends StatefulWidget {
  const LayoutPerson({
    required ControllerDialogPeople controller,
    required ListItemPerson person,
    required ThemeExtensionDialogPeople dialogTheme,
    required double controlColumnWidth,
    super.key,
  }) : _controller = controller,
       _person = person,
       _dialogTheme = dialogTheme,
       _controlColumnWidth = controlColumnWidth;

  @override
  State<LayoutPerson> createState() => _LayoutPersonState();

  final ControllerDialogPeople _controller;
  final ListItemPerson _person;
  final ThemeExtensionDialogPeople _dialogTheme;
  final double _controlColumnWidth;
}

class _LayoutPersonState extends State<LayoutPerson> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHot = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHot = false;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ControlPersonSelected(controller: widget._controller, person: widget._person),
          SizedBox(
            width: widget._dialogTheme.dialogBaseTheme.horizontalSpacing,
          ),
          Expanded(
            child: ControlFormField(
              label: 'firstName',
              property: widget._person.person.firstName,
              editable: _isHot,
              noLabel: true,
            ),
          ),
          SizedBox(
            width: widget._dialogTheme.dialogBaseTheme.horizontalSpacing,
          ),
          Expanded(
            child: ControlFormField(
              label: 'lastName',
              property: widget._person.person.lastName,
              editable: _isHot,
              noLabel: true,
            ),
          ),
          ControlPersonCommand(
            controller: widget._controller,
            person: widget._person,
            commandColumnWidth: widget._controlColumnWidth,
            isHot: _isHot,
          ),
        ],
      ),
    );
  }

  bool _isHot = false;
}
