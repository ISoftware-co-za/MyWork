import 'dart:collection';
import 'package:client_interfaces1/model/person.dart';
import 'package:flutter/cupertino.dart';

import 'model_property_context.dart';

class PersonList extends ChangeNotifier {
  List<Person> get peopleAdded => UnmodifiableListView(_peopleAdded);
  List<Person> get people => UnmodifiableListView(_people);
  int removeCount = 0;

  PersonList(ModelPropertyContext modelPropertyContext)
    : _modelPropertyContext = modelPropertyContext {
    _people.addAll([
      Person(modelPropertyContext, '1', 'First name 1', 'Last name 1'),
      Person(modelPropertyContext, '2', 'First name 2', 'Last name 2'),
      Person(modelPropertyContext, '3', 'First name 3', 'Last name 3'),
      Person(modelPropertyContext, '4', 'First name 4', 'Last name 4'),
      Person(modelPropertyContext, '5', 'First name 5', 'Last name 5'),
    ]);
  }

  void add(Person person) {
    _peopleAdded.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    if (person.isNew) {
      if (person.firstName.isChanged) {
        _modelPropertyContext.removeChangedProperty(person.firstName);
      }
      if (person.lastName.isChanged) {
        _modelPropertyContext.removeChangedProperty(person.lastName);
      }
      _peopleAdded.remove(person);
    } else {
      _people.remove(person);
      _peopleRemoved.add(person);
    }
    removeCount = _peopleRemoved.length;
    notifyListeners();
  }

  bool validate() {
    bool areUpdatesValid = true;
    peopleAdded.forEach((person) {
      areUpdatesValid &= person.validate();
    });
    people.forEach((person) {
      if (person.isUpdated) {
        areUpdatesValid &= person.validate();
      }
    });
    return areUpdatesValid;
  }

  void acceptChanges() {}

  void rejectChanges() {}

  final ModelPropertyContext _modelPropertyContext;
  final List<Person> _peopleAdded = [];
  final List<Person> _peopleRemoved = [];
  final List<Person> _people = [];
}
