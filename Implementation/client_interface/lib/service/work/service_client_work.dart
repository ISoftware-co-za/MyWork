library service_client_work;

import 'dart:convert';

import 'package:client_interfaces1/service/work/load_work_details.dart';

import '../service_client_base.dart';
import '../update_entity.dart';

part 'list_work.dart';
part 'create_work.dart';

class ServiceClientWork extends ServiceClientBase {

  ServiceClientWork(super.baseUrl);

  Future<ListWorkResponse> listAll() async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work');
    final response = await httpGet(uri, headers);
    return processResponse(response, 200,
            () => ListWorkResponse.fromJson(jsonDecode(response.body)))!
        as ListWorkResponse;
  }

  Future<WorkDetailsResponse> loadDetails(String id) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work/$id');
    final response = await httpGet(uri, headers);
    return processResponse(response, 200,
            () => WorkDetailsResponse.fromJson(jsonDecode(response.body)))!
    as WorkDetailsResponse;
  }

  Future<ServiceClientResponse?> create(RequestCreateWork request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(response, 201,
        () => ResponseWorkCreate.fromJson(jsonDecode(response.body)))!;
  }

  Future<ServiceClientResponse?> update(UpdateEntityRequest request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work/${request.id}');
    final body = jsonEncode(request.toJson());
    final response = await httpPatch(uri, headers, body);
    return processResponse(response, 204, () => null);
  }

  Future<ServiceClientResponse?> delete(String id) async {
    Map<String, String> headers = setupCommonHeaders();
    var uri = generateUri('/work/$id');
    final response = await httpDelete(uri, headers);
    return processResponse(response, 204, () => null);
  }
}
