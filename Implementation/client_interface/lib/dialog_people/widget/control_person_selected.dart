import 'package:flutter/material.dart';

import '../controller/controller_dialog_people.dart';
import '../controller/list_item_person_base.dart';

class ControlPersonSelected extends StatefulWidget {
  const ControlPersonSelected({
    required ControllerDialogPeople controller,
    required ListItemPersonBase person,
    super.key,
  }) : _controller = controller,
       _person = person;

  @override
  State<ControlPersonSelected> createState() => _ControlPersonSelectedState();

  final ControllerDialogPeople _controller;
  final ListItemPersonBase _person;
}

class _ControlPersonSelectedState extends State<ControlPersonSelected> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget._controller.selectedPerson,
      builder: (context, value, child) {
        return SizedBox(
          width: 40,
          child: Radio(
            value: widget._person,
            groupValue: widget._controller.selectedPerson.value,
            onChanged: (value) {
              setState(() {
                widget._controller.selectedPerson.value = widget._person;
              });
            }),
        );
      }
    );
  }
}
