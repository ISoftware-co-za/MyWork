import 'dart:collection';
import 'package:client_interfaces1/model/person.dart';
import 'package:client_interfaces1/service/people/get_all_people_response.dart';
import 'package:client_interfaces1/service/people/modify_people.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../service/people/person_details.dart';
import '../service/people/service_client_people.dart';
import '../service/update_entity.dart';
import 'model_property_context.dart';

class PersonList extends ChangeNotifier {
  List<Person> get peopleAdded => UnmodifiableListView(_peopleAdded);
  List<Person> get people => UnmodifiableListView(_people);
  ModelPropertyContext modelPropertyContext = ModelPropertyContext(name: 'PersonList');
  int removeCount = 0;

  Future loadAll() async {
    _people.clear();
    GetAllPeopleResponse response = await _serviceClient.listAll();
    _people.addAll(response.people.map((item) => Person(modelPropertyContext, item.id, item.firstName, item.lastName)));
  }

  Person? find(String id) => _people.firstWhere((person) => person.id == id);

  void add(Person person) {
    _peopleAdded.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    if (person.isNew) {
      if (person.firstName.isChanged) {
        modelPropertyContext.removeChangedProperty(person.firstName);
      }
      if (person.lastName.isChanged) {
        modelPropertyContext.removeChangedProperty(person.lastName);
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

  List<String> getPeopleRemovedIds() {
    final removedPeopleIds = <String>[];
    if (_peopleRemoved.length > 0) {
      for(int index = 0; index < _peopleRemoved.length; ++index) {
        removedPeopleIds.add(_peopleRemoved[index].id);
      }
    }
    return removedPeopleIds;
  }

  Future acceptChanges() async {
    List<PersonDetails>? addedPeople;
    List<UpdateEntityRequest>? updatedPeople;
    List<String>? removedPeopleIds = getPeopleRemovedIds();

    if (_peopleAdded.length > 0) {
      addedPeople = _peopleAdded
          .map((person) =>
          PersonDetails(person.firstName.value, person.lastName.value))
          .toList();
    }
    if (modelPropertyContext.hasChanges.value) {
      updatedPeople = [];
      for (int index = 0; index < _people.length; ++index) {
        final person = _people[index];
        if (person.isUpdated) {
          final List<UpdateEntityProperty> updatedProperties = [];
          if (person.firstName.isChanged) {
            updatedProperties.add(UpdateEntityProperty(name: 'firstName', value: person.firstName.value));
          }
          if (person.lastName.isChanged) {
            updatedProperties.add(UpdateEntityProperty(name: 'lastName', value: person.lastName.value));
          }
          final updateRequest = UpdateEntityRequest(
              id: person.id, updatedProperties: updatedProperties);
          updatedPeople.add(updateRequest);
        }
      }
    }
    final request = ModifyPeopleRequest(addedPeople, updatedPeople, removedPeopleIds);
    final response = await _serviceClient.modify(request);
    bool mustSortPeople = false;
    if (response.addedPeople != null) {
      for (int index = 0; index < response.addedPeople!.length; ++index) {
        if (response.addedPeople![index].id.isNotEmpty) {
          _peopleAdded[index].id = response.addedPeople![index].id;
          _people.add(_peopleAdded[index]);
          mustSortPeople = true;
        }
      }
    }

    if (mustSortPeople) {
      _people.sort();
    }

    _peopleAdded.clear();
    _peopleRemoved.clear();
    modelPropertyContext.acceptChanges();
    String errorMessage = '';
    if (response.addedPeopleMessage != null) {
      errorMessage += response.addedPeopleMessage!;
    }
    if (response.updatePeopleErrorMessage != null) {
      errorMessage += response.addedPeopleMessage!;
    }
    if (response.removePeopleErrorMessage != null) {
      errorMessage += response.addedPeopleMessage!;
    }
    if (errorMessage.isNotEmpty) {
      throw Exception(errorMessage);
    }
  }

  void rejectChanges() {}

  final List<Person> _peopleAdded = [];
  final List<Person> _peopleRemoved = [];
  final List<Person> _people = [];
  final ServiceClientPeople _serviceClient = GetIt.instance<ServiceClientPeople>();
}
