part of people_dialog_controller;

class ListItemPersonBase {
  //#region ATTRIBUTES

  final Person person;
  String lowercaseFirstName = '';
  String lowercaseLastName = '';

  //#endregion

  //#region CONSTRUCTION

  ListItemPersonBase(this.person, ControllerDialogPeople controller) : _controller = controller {
    person.firstName.addListener(_onFirstNameChanged);
    person.lastName.addListener(_onLastNameChanged);
    _onFirstNameChanged();
    _onLastNameChanged();
  }

  //#endregion

  //#region METHODS

  bool matchesFilter(String criteria) {
    if (criteria.isEmpty) {
      return true;
    }
    return lowercaseFirstName.contains(criteria) ||
        lowercaseLastName.contains(criteria);
  }

  //#endregion

  //#region PRIVATE EVENT HANDLERS

  void _onFirstNameChanged() {
    lowercaseFirstName = person.firstName.value.toLowerCase();
  }

  void _onLastNameChanged() {
    lowercaseLastName = person.lastName.value.toLowerCase();
  }

  //#endregion

//#region PRIVATE FIELDS

  final ControllerDialogPeople _controller;

//#endregion
}
