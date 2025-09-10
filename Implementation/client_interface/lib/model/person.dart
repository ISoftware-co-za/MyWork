import 'package:client_interfaces1/model/model_property_context.dart';
import 'package:client_interfaces1/model/validator_base.dart';
import 'package:client_interfaces1/service/update_entity.dart';

import 'model_property.dart';

class Person extends PropertyOwner implements UpdateEntityPropertyProvider, Comparable<Person> {
  late String id;
  late final ModelProperty<String> firstName;
  late final ModelProperty<String> lastName;
  dynamic get providedProperty => id;

  bool get isNew => id.isEmpty;
  bool get isUpdated => firstName.isChanged || lastName.isChanged;

  Person(ModelPropertyContext context, String id, String firstName, String lastName) : super(context) {
    this.id = id;
    _initialiseInstance(firstName, lastName);
  }

  Person.create(ModelPropertyContext context) : super(context) {
    id = '';
    _initialiseInstance('', '');
  }

  Person.createWithFullName(ModelPropertyContext context, String fullName) : super(context) {
    id = '';
    final List<String> words = fullName.split(' ');
    final String firstName = words.isNotEmpty ? words.first : '';
    final String lastName = words.length > 1 ? words.sublist(1).join(' ') : '';
    _initialiseInstance(firstName, lastName);
  }

  bool validate() {
    return firstName.validate() && lastName.validate();
  }

  @override
  String toString() {
    return '${firstName.value} ${lastName.value}';
  }

  @override
  int compareTo(Person other) {
    return Comparable.compare(lastName.value, other.lastName.value);
  }

  void _initialiseInstance(String firstName, String lastName) {
    this.firstName = ModelProperty<String>(context: context, value: firstName, validators: [
      ValidatorRequired(invalidMessageTemplate: 'First name is required'),
      ValidatorMaximumCharacters(maximumCharacters: 30, invalidMessageTemplate: 'First name cannot exceed 30 characters')
    ] );

    this.lastName = ModelProperty<String>(context: context, value: lastName, validators: [
      ValidatorRequired(invalidMessageTemplate: 'Last name is required'),
      ValidatorMaximumCharacters(maximumCharacters: 30, invalidMessageTemplate: 'Last name cannot exceed 30 characters')
    ] );

    properties = {
      'firstName': this.firstName,
      'lastName': this.lastName,
    };
  }
}