library people_dialog_controller;

import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/model/activity_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../controller/controller_base.dart';
import '../../model/person.dart';
import '../../model/person_list.dart';
import 'selected_person_registry.dart';

part 'list_item_add_person.dart';
part 'list_item_new_person.dart';
part 'list_item_person.dart';
part 'list_item_person_base.dart';

typedef ActionDialogPeople = void Function(Person selectedPerson);

class ControllerDialogPeople extends ControllerBase {
  //#region ATTRIBUTES

  final ValueNotifier<Person?> selectedPerson = ValueNotifier(null);
  final ValueNotifier<List<Object>> items = ValueNotifier([]);
  final ValueNotifier<String> filterCriteria = ValueNotifier('');
  ValueListenable<bool> get hasChanges => _hasChanges;
  late final SelectedPersonRegistry selectedPersonRegistry;

  //#endregion

  //#region CONSTRUCTION

  ControllerDialogPeople(
    PersonList personList,
    ActivityList activityList,
    ActionDialogPeople dialogAction,
    BuildContext buildContext,
  ) : _personList = personList,
      _activityList = activityList,
      _dialogAction = dialogAction,
      _buildContext = buildContext {
    selectedPerson.addListener(_onPersonSelected);
    filterCriteria.addListener(_onFilterCriteriaChanged);
    _constructList();
    _personList.modelPropertyContext.hasChanges.addListener(_setHasChanges);
    selectedPersonRegistry = SelectedPersonRegistry(_personList, selectedPerson);
  }

  //#endregion

  //#region EVENT HANDLERS

  void onAddPerson() {
    _personList.add(Person.create(_personList.modelPropertyContext));
    _constructList();
  }

  void onRemoveAddedPerson(ListItemNewPerson person) {
    _personList.remove(person.person);
    _constructList();
  }

  void onDeletePerson(ListItemPerson person) {
    _personList.remove(person.person);
    _setHasChanges();
    _constructList();
  }

  Future onAcceptUpdates() async {
    if (_hasChanges.value) {
      List<String> peopleRemoved = _personList.getPeopleRemovedIds();
      await _personList.acceptChanges();
      if (peopleRemoved.isNotEmpty) {
        _activityList.unlinkDeletedRecipients(peopleRemoved);
      }
    }
    if (selectedPerson.value != null) {
      _dialogAction(selectedPerson.value!);
    }
    onClose();
  }

  void onClose() {
    Navigator.pop(_buildContext);
  }

  //#endregion

  //#region PRIVATE EVENT HANDLERS

  void _onPersonSelected() {
    Executor.runCommand(
      'ControllerDialogPeople.onPersonSelected',
      'LayoutDialogPeople',
      () {
        assert(selectedPerson.value != null, 'No person is selected');
        if (_hasChanges.value == false) {
          _dialogAction(selectedPerson.value!);
          onClose();
        }
      },
    );
  }

  void _onFilterCriteriaChanged() {
    Executor.runCommand(
      'ControllerDialogPeople._onFilterCriteriaChanged',
      'LayoutDialogPeople',
      () {
        _lowercaseFilterCriteria = filterCriteria.value.toLowerCase();
        _constructList();
      },
    );
  }

  //#endregion

  //#region PRIVATE METHODS

  void _setHasChanges() {
    _hasChanges.value =
        _personList.modelPropertyContext.hasChanges.value ||
        _personList.removeCount > 0;
  }

  void _constructList() {
    final List<Object> people = [];
    Person? currentlySelectedPerson = null;

    if (selectedPerson.value != null) {
      currentlySelectedPerson = selectedPerson.value!;
    }

    _personList.peopleAdded.forEach((person) {
      final addedPerson = ListItemNewPerson(person, this);
      people.add(addedPerson);
      if (person == currentlySelectedPerson) {
        selectedPerson.value = person;
      }
    });
    people.add(ListItemAddPerson());
    _addFilteredExistingPeople(people, currentlySelectedPerson);

    items.value = people;
  }

  void _addFilteredExistingPeople(List<dynamic> people, Person? currentlySelectedPerson) {
    _personList.people.forEach((person) {
      final listItemPerson = ListItemPerson(person, this);
      if (listItemPerson.matchesFilter(_lowercaseFilterCriteria)) {
        people.add(listItemPerson);
      }
      if (person == currentlySelectedPerson) {
        selectedPerson.value = currentlySelectedPerson;
      }
    });
  }

  //#endregion

  //#region PRIVATE FIELDS

  final BuildContext _buildContext;
  final ActionDialogPeople _dialogAction;
  final _hasChanges = ValueNotifier<bool>(false);
  late final PersonList _personList;
  late final ActivityList _activityList;
  String _lowercaseFilterCriteria = '';

  //#endregion
}