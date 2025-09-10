import 'package:client_interfaces1/service/people/person.dart';

import '../service_client_base.dart';


class GetAllPeopleResponse extends ServiceClientResponse {
  List<Person> people;
  GetAllPeopleResponse(this.people);

  factory GetAllPeopleResponse.fromJson(Map<String, dynamic> json) {
    var peopleJson = json['people'] as List<dynamic>? ?? [];
    List<Person> people = peopleJson.map((e) => Person.fromJson(e as Map<String, dynamic>)).toList();
    return GetAllPeopleResponse(people);
  }

}