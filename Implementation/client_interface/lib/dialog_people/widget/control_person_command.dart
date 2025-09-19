import 'package:client_interfaces1/execution/executor.dart';
import 'package:flutter/material.dart';

import '../../ui_toolkit/control_icon_button.dart';
import '../../ui_toolkit/control_icon_button_reject.dart';
import '../controller/controller_dialog_people.dart';

class ControlPersonCommand extends StatelessWidget {
  const ControlPersonCommand({
    required ListItemPerson person,
    required double commandColumnWidth,
    required bool isHot,
    super.key,
  }) : _person = person,
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
            onPressed: () => Executor.runCommand('ControlIconButtonReject.close.onPressed', 'LayoutDialogPeople', _person.onRejectChanges)
          );
        } else if (_isHot) {
          child = ControlIconButton(
            Icons.delete,
            onPressed: () => Executor.runCommand('ControlPersonCommand.delete.onPressed', 'LayoutDialogPeople', _person.onDelete)
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

  final ListItemPerson _person;
  final double _commandColumnWidth;
  final bool _isHot;
}
