import 'package:client_interfaces1/service/people/person_details.dart';

class PersonItem extends PersonDetails {
  String id;
  PersonItem(this.id, super.firstName, super.lastName);

  factory PersonItem.fromJson(Map<String, dynamic> json) {
    return PersonItem(
      json['id'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
    );
  }
}