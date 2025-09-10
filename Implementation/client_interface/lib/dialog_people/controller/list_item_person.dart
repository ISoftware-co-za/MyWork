import 'package:client_interfaces1/dialog_people/controller/controller_dialog_people.dart';
import 'package:flutter/cupertino.dart';

import 'list_item_person_base.dart';

class ListItemPerson extends ListItemPersonBase {
  final ValueNotifier<bool> isChanged = ValueNotifier<bool>(false);

  ListItemPerson(ControllerDialogPeople controller, super.person) : _controller = controller{
    person.firstName.addListener(onPropertyChanged);
    person.lastName.addListener(onPropertyChanged);
    _setIsChanged();
  }

  void onPropertyChanged() {
    _setIsChanged();
  }

  void onRejectChanges() {
    person.firstName.discardChange();
    person.lastName.discardChange();
  }

  void onDelete() {
    _controller.onDeletePerson(this);
  }

  void _setIsChanged() {
    isChanged.value = person.firstName.isChanged || person.lastName.isChanged;
  }

  final ControllerDialogPeople _controller;
}
