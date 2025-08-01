import 'package:client_interfaces1/dialog_people/controller/list_item_add_person.dart';
import 'package:client_interfaces1/dialog_people/controller/list_item_new_person.dart';
import 'package:client_interfaces1/dialog_people/controller/list_item_person.dart';
import 'package:client_interfaces1/dialog_people/widget/control_add_person.dart';
import 'package:client_interfaces1/dialog_people/widget/control_new_person.dart';
import 'package:client_interfaces1/dialog_people/widget/layout_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme_extension_dialog_people.dart';
import '../../theme/theme_extension_text_field.dart';
import '../controller/controller_dialog_people.dart';

class ControlList extends StatelessWidget {
  const ControlList({required ControllerDialogPeople controller, required ThemeExtensionDialogPeople dialogTheme, required ThemeExtensionTextField textFieldTheme, super.key}) :
        _controller = controller,
  _dialogTheme = dialogTheme,
  _textFieldTheme = textFieldTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_dialogTheme.dialogBaseTheme.padding),
      child: ValueListenableBuilder(
          valueListenable: _controller.list, builder:  (BuildContext context, List<dynamic> value, Widget? child) {
           return ListView.builder(
             itemCount: 2 * value.length,
               itemBuilder: (BuildContext context, int index) {
               if (index % 2 == 1)
                 return SizedBox(height: _dialogTheme.dialogBaseTheme.verticalSpacing);
               int itemIndex = (index/2).toInt();
               dynamic item = value[itemIndex];
               if (item is ListItemAddPerson) {
                 return ControlAddPerson(controller: _controller);
               } else if (item is ListItemNewPerson) {
                 return ControlNewPerson(controller: _controller, listItem: item, dialogTheme: _dialogTheme, textFieldTheme: _textFieldTheme);
               } else if (item is ListItemPerson) {
                 return LayoutPerson(controller: _controller, person: item, dialogTheme: _dialogTheme, controlColumnWidth: _dialogTheme.commandColumnWidth);
               } else {
                 throw Exception('The type ${item.runtimeType} is not handled by ControlList. Please add code to handle this type.' );
               }

           });
      }),
    );
  }

  final ControllerDialogPeople _controller;
  final ThemeExtensionDialogPeople _dialogTheme;
  final ThemeExtensionTextField _textFieldTheme;

}
