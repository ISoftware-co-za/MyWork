import 'package:client_interfaces1/dialog_people/controller/controller_dialog_people.dart';
import 'package:client_interfaces1/dialog_people/controller/list_item_person.dart';
import 'package:flutter/material.dart';

import '../../ui_toolkit/control_icon_button.dart';
import '../../ui_toolkit/control_icon_button_reject.dart';

class ControlPersonCommand extends StatelessWidget {
  const ControlPersonCommand({
    required ControllerDialogPeople controller,
    required ListItemPerson person,
    required double commandColumnWidth,
    required bool isHot,
    super.key,
  }) : _controller = controller,
       _person = person,
       _commandColumnWidth = commandColumnWidth,
       _isHot = isHot;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _person.isChanged,
      builder: (BuildContext context, bool value, Widget? child) {
        Widget child;
        if (_person.isChanged.value) {
          child = ControlIconButtonReject(
            Icons.close,
            onPressed: _person.onRejectChanges,
          );
        } else if (_isHot) {
          child = ControlIconButton(
            Icons.delete,
            onPressed: () {
              _controller.onDeletePerson(_person);
            },
          );
        } else {
          child = SizedBox.shrink();
        }
        return SizedBox(
          width: _commandColumnWidth,
          child: Center(child: child),
        );
      },
    );
  }

  final ControllerDialogPeople _controller;
  final ListItemPerson _person;
  final double _commandColumnWidth;
  final bool _isHot;
}
