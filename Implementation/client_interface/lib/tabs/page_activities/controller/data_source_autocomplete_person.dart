import 'package:client_interfaces1/execution/executor.dart';
import 'package:client_interfaces1/model/person_list.dart';
import 'package:client_interfaces1/tabs/page_activities/controller/list_item_person.dart';

import '../../../ui_toolkit/form/form.dart';

typedef PersonSelectedHandler = void Function(ListItemPerson selectedPerson);
typedef PersonEnteredHandler = void Function(String text);

class DataSourceAutocompletePerson extends AutocompleteDataSource {
  DataSourceAutocompletePerson({
    required PersonList people,
    required PersonSelectedHandler onPersonSelected,
    required PersonEnteredHandler onPersonEntered,
  }) : _people = people, _onPersonSelected = onPersonSelected, _onPersonEntered = onPersonEntered {
    _people.addListener(_onPeopleChanged);
    _onPeopleChanged();
  }

  @override
  Iterable<Object> emptyList() => _emptyList;

  @override
  Iterable<Object> listItems([String filter = '']) {
    final filteredPeople = <ListItemPerson>[];
    final lowercaseFilter = filter.toLowerCase();
    _peopleList.forEach((person) {
      if (person.doesMatch(lowercaseFilter)) {
        filteredPeople.add(person);
      }
    });
    return filteredPeople;
  }

  @override
  void onItemSelected(Object item) {
    Executor.runCommand('DataSourceAutocompletePerson.onItemSelected', 'LayoutFormActivity', () => _onPersonSelected(item as ListItemPerson));
  }

  @override
  void onTextEntered(String text) {
    Executor.runCommand('DataSourceAutocompletePerson.onTextEntered', 'LayoutFormActivity', () => _onPersonEntered(text));
  }

  void _onPeopleChanged() {
    _constructPeopleList();
  }

  void _constructPeopleList() {
    List<ListItemPerson> updatedPeopleList = [];
    _people.people.forEach(
      (person) => updatedPeopleList.add(ListItemPerson(person)),
    );
    _peopleList.clear();
    _peopleList.addAll(updatedPeopleList);
  }

  final List<ListItemPerson> _emptyList = [];
  final List<ListItemPerson> _peopleList = [];
  final PersonList _people;
  final PersonSelectedHandler _onPersonSelected;
  final PersonEnteredHandler _onPersonEntered;
}
