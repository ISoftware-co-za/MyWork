import 'package:flutter/material.dart';

import '../../ui_toolkit/control_icon_button_large.dart';
import '../controller/controller_dialog_people.dart';

class ControlAddPerson extends StatelessWidget {
  const ControlAddPerson({required ControllerDialogPeople controller, super.key}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ControlIconButtonLarge(icon: Icon(Icons.add),
        onPressed: () {
          _controller.onAddPerson();
        }
    ));
  }

  final ControllerDialogPeople _controller;
}
