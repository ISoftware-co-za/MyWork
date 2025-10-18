import 'package:flutter/material.dart';

import '../../theme/theme_extension_dialog_people.dart';
import '../../theme/theme_extension_spacing.dart';
import '../../ui_toolkit/form/form.dart';
import '../controller/controller_dialog_people.dart';
import 'control_person_command.dart';
import 'control_person_selected.dart';

class LayoutPerson extends StatefulWidget {
  const LayoutPerson({
    required ControllerDialogPeople controller,
    required ListItemPerson person,
    required ThemeExtensionSpacing spacingTheme,
    required ThemeExtensionDialogPeople dialogTheme,
    required double controlColumnWidth,
    super.key,
  }) : _controller = controller,
       _person = person,
       _spacingTheme = spacingTheme,
       _dialogTheme = dialogTheme,
       _controlColumnWidth = controlColumnWidth;

  @override
  State<LayoutPerson> createState() => _LayoutPersonState();

  final ControllerDialogPeople _controller;
  final ListItemPerson _person;
  final ThemeExtensionSpacing _spacingTheme;
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
          ControlPersonSelected(
            controller: widget._controller,
            person: widget._person.person,
            dialogTheme: widget._dialogTheme,
          ),
          SizedBox(width: widget._spacingTheme.horizontalSpacing),
          Expanded(
            child: ControlFormField(
              label: 'firstName',
              property: widget._person.person.firstName,
              editable: _isHot,
              noLabel: true,
            ),
          ),
          SizedBox(width: widget._spacingTheme.horizontalSpacing),
          Expanded(
            child: ControlFormField(
              label: 'lastName',
              property: widget._person.person.lastName,
              editable: _isHot,
              noLabel: true,
            ),
          ),
          ControlPersonCommand(
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
