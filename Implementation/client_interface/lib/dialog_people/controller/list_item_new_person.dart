part of people_dialog_controller;

class ListItemNewPerson extends ListItemPersonBase {
  ListItemNewPerson(super.person, super.controller);

  void onDelete() {
    _controller.onRemoveAddedPerson(this);
  }
}