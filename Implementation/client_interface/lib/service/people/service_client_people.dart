import 'dart:convert';

import 'package:client_interfaces1/service/people/list_all_people_response.dart';
import 'package:client_interfaces1/service/people/modify_people.dart';

import '../service_client_base.dart';

class ServiceClientPeople extends ServiceClientBase {
  ServiceClientPeople(super.baseUrl);

  Future<ListAllPeopleResponse> listAll() async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/people');
    final response = await httpGet(uri, headers);
    return processResponse(response, 200,
            () => ListAllPeopleResponse.fromJson(jsonDecode(response.body)))!
    as ListAllPeopleResponse;
  }

  Future<ModifyPeopleResponse> modify(ModifyPeopleRequest request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/people');
    final json = request.toJson();
    final body = jsonEncode(json);
    final response = await httpPost(uri, headers, body);
    return processResponse(response, 200,
            () => ModifyPeopleResponse.fromJson(jsonDecode(response.body)))!
    as ModifyPeopleResponse;
  }
}