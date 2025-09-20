import 'package:client_interfaces1/service/people/person_item.dart';

import '../service_client_base.dart';


class ListAllPeopleResponse extends ServiceClientResponse {
  List<PersonItem> people;
  ListAllPeopleResponse(this.people);

  factory ListAllPeopleResponse.fromJson(Map<String, dynamic> json) {
    var peopleJson = json['people'] as List<dynamic>? ?? [];
    List<PersonItem> people = peopleJson.map((e) => PersonItem.fromJson(e as Map<String, dynamic>)).toList();
    return ListAllPeopleResponse(people);
  }

}