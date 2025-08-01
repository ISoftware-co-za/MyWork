import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../controller/controller_base.dart';
import '../../model/model_property_context.dart';
import '../../model/person.dart';
import '../../model/person_list.dart';
import 'list_item_person_base.dart';
import 'list_item_person.dart';
import 'list_item_new_person.dart';
import 'list_item_add_person.dart';

typedef ActionDialogPeople =
    void Function(Person? person, PersonList? personList);

class ControllerDialogPeople extends ControllerBase {
  final ValueNotifier<ListItemPersonBase?> selectedPerson = ValueNotifier(null);
  final ValueNotifier<List<dynamic>> list = ValueNotifier([]);
  final ValueNotifier<String> filterCriteria = ValueNotifier('');
  ValueListenable<bool> get hasChanges => _hasChanges;
  final ModelPropertyContext modelPropertyContext = ModelPropertyContext(
    name: 'ControllerDialogPeople',
  );

  ControllerDialogPeople(BuildContext buildContext) : _buildContext = buildContext {
    _personList = new PersonList(modelPropertyContext);
    selectedPerson.addListener(onPersonSelected);
    filterCriteria.addListener(_onFilterCriteriaChanged);
    _constructList();
    modelPropertyContext.hasChanges.addListener(_onHasChanges);
  }

  void onAddPerson() {
    _personList.add(Person.create(modelPropertyContext));
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
    if (modelPropertyContext.hasChanges.value == false) {
      debugPrint('Person selected ${selectedPerson.value!.person.firstName.value} ${selectedPerson.value!.person.lastName.value}');
      onClose();
    }
  }

  void onAcceptUpdates() {
    if (modelPropertyContext.hasChanges.value) {
      debugPrint('Save changes');
    }
    if (selectedPerson.value != null) {
      debugPrint('Person selected ${selectedPerson.value!.person.firstName.value} ${selectedPerson.value!.person.lastName.value}');
    }
    onClose();
  }

  void onClose() {
    Navigator.pop(_buildContext);
  }

  void _onHasChanges() {
    _hasChanges.value = modelPropertyContext.hasChanges.value || _personList.removeCount > 0;
  }

  void _onFilterCriteriaChanged() {
    lowercaseFilterCriteria = filterCriteria.value.toLowerCase();
    _constructList();
  }

  void _constructList() {
    final List<dynamic> people = [];

    _personList.peopleAdded.forEach((person) {
      people.add(ListItemNewPerson(person));
    });
    people.add(ListItemAddPerson());
    _addFilteredExistingPeople(people);

    list.value = people;
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
  final _hasChanges = ValueNotifier<bool>(false);
  late final PersonList _personList;
  String lowercaseFilterCriteria = '';
}
