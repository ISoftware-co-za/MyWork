import 'package:flutter/material.dart';

import '../../model/person.dart';
import '../../model/person_list.dart';

class SelectedPersonRegistry implements RadioGroupRegistry<Person> {
  SelectedPersonRegistry(PersonList people, ValueNotifier<Person?> selectedPerson) : _selectedPerson = selectedPerson {
  }

  @override
  Person? get groupValue => _currentValue;

  @override
  ValueChanged<Person?> get onChanged => _onValueChanged;

  @override
  void registerClient(RadioClient<Person> radio) {
    _map[radio.radioValue] = radio;
  }

  @override
  void unregisterClient(RadioClient<Person> radio) {
    _map.remove(radio.radioValue);
  }

  void _onValueChanged(Person? value) {
    _currentValue = value;
    _selectedPerson.value = value;
  }

  Map<Person, RadioClient<Person>> _map = {};
  Person? _currentValue;
  final ValueNotifier<Person?> _selectedPerson;
}