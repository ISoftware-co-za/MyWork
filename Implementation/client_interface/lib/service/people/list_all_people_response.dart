import 'package:client_interfaces1/service/people/person.dart';

import '../service_client_base.dart';


class ListAllPeopleResponse extends ServiceClientResponse {
  List<Person> people;
  ListAllPeopleResponse(this.people);

  factory ListAllPeopleResponse.fromJson(Map<String, dynamic> json) {
    var peopleJson = json['people'] as List<dynamic>? ?? [];
    List<Person> people = peopleJson.map((e) => Person.fromJson(e as Map<String, dynamic>)).toList();
    return ListAllPeopleResponse(people);
  }

}