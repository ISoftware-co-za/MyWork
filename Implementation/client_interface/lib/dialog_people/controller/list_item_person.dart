part of people_dialog_controller;

class ListItemPerson extends ListItemPersonBase {
  final ValueNotifier<bool> isChanged = ValueNotifier<bool>(false);

  ListItemPerson(super.person, super.controller) {
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
}
