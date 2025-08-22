import 'package:client_interfaces1/model/model_property_context.dart';
import 'package:client_interfaces1/model/validator_base.dart';

import 'model_property.dart';

class Person extends PropertyOwner {
  late final String id;
  late final ModelProperty<String> firstName;
  late final ModelProperty<String> lastName;

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

  bool validate() {
    return firstName.validate() && lastName.validate();
  }

  @override
  String toString() {
    return '${firstName.value} ${lastName.value}';
  }

  void _initialiseInstance(String firstName, String lastName) {
    this.firstName = ModelProperty<String>(context: context, value: firstName, validators: [
      ValidatorRequired(invalidMessageTemplate: 'First name is required'),
      ValidatorMaximumCharacters(maximumCharacters: 60, invalidMessageTemplate: 'First name cannot exceed 60 characters')
    ] );

    this.lastName = ModelProperty<String>(context: context, value: lastName, validators: [
      ValidatorRequired(invalidMessageTemplate: 'Last name is required'),
      ValidatorMaximumCharacters(maximumCharacters: 60, invalidMessageTemplate: 'Last name cannot exceed 60 characters')
    ] );

    properties = {
      'firstName': this.firstName,
      'lastName': this.lastName,
    };
  }
}