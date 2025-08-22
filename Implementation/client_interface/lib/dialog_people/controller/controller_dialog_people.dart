import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../controller/controller_base.dart';
import '../../model/person.dart';
import '../../model/person_list.dart';
import 'list_item_person_base.dart';
import 'list_item_person.dart';
import 'list_item_new_person.dart';
import 'list_item_add_person.dart';

typedef ActionDialogPeople =
    void Function(Person selectedPerson);

class ControllerDialogPeople extends ControllerBase {
  final ValueNotifier<ListItemPersonBase?> selectedPerson = ValueNotifier(null);
  final ValueNotifier<List<Object>> items = ValueNotifier([]);
  final ValueNotifier<String> filterCriteria = ValueNotifier('');
  ValueListenable<bool> get hasChanges => _hasChanges;

  ControllerDialogPeople(ActionDialogPeople dialogAction, BuildContext buildContext) : _dialogAction = dialogAction, _buildContext = buildContext {
    _personList = new PersonList();
    selectedPerson.addListener(onPersonSelected);
    filterCriteria.addListener(_onFilterCriteriaChanged);
    _constructList();
    _personList.modelPropertyContext.hasChanges.addListener(_onHasChanges);
  }

  void onAddPerson() {
    _personList.add(Person.create(_personList.modelPropertyContext));
    _constructList();
  }

  void onDeletePerson(ListItemPerson person) {
    _personList.remove(person.person);
    _onHasChanges();
    _constructList();
  }

  void onRemoveNewPerson(ListItemNewPerson person) {
    _personList.remove(person.person);
    _constructList();
  }

  void onPersonSelected() {
    assert(selectedPerson.value != null, 'No person is selected');
    if (_personList.modelPropertyContext.hasChanges.value == false) {
      _dialogAction(selectedPerson.value!.person);
      onClose();
    }
  }

  void onAcceptUpdates() {
    if (_personList.modelPropertyContext.hasChanges.value) {
      debugPrint('Save changes');
    }
    if (selectedPerson.value != null) {
      _dialogAction(selectedPerson.value!.person);
    }
    onClose();
  }

  void onClose() {
    Navigator.pop(_buildContext);
  }

  void _onHasChanges() {
    _hasChanges.value = _personList.modelPropertyContext.hasChanges.value || _personList.removeCount > 0;
  }

  void _onFilterCriteriaChanged() {
    lowercaseFilterCriteria = filterCriteria.value.toLowerCase();
    _constructList();
  }

  void _constructList() {
    final List<Object> people = [];

    _personList.peopleAdded.forEach((person) {
      people.add(ListItemNewPerson(person));
    });
    people.add(ListItemAddPerson());
    _addFilteredExistingPeople(people);

    items.value = people;
  }

  void _addFilteredExistingPeople(List<dynamic> people) {
    _personList.people.forEach((person) {
      final listItemPerson = ListItemPerson(this, person);
      if (listItemPerson.matchesFilter(lowercaseFilterCriteria)) {
        people.add(listItemPerson);
      }
    });
  }

  final BuildContext _buildContext;
  final ActionDialogPeople _dialogAction;
  final _hasChanges = ValueNotifier<bool>(false);
  late final PersonList _personList;
  String lowercaseFilterCriteria = '';
}
