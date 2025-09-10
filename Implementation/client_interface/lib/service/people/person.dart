import 'package:client_interfaces1/service/people/person_details.dart';

class Person extends PersonDetails {
  String id;
  Person(this.id, super.firstName, super.lastName);

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['id'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
    );
  }
}