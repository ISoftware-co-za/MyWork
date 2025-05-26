library service_client_work;

import 'dart:convert';

import 'package:client_interfaces1/service/work/work_details_response.dart';

import '../service_client_base.dart';

part 'work_list.dart';
part 'create_work.dart';
part 'work_update.dart';

class ServiceClientWork extends ServiceClientBase {
  //#region CONSTRUCTION

  ServiceClientWork(super.baseUrl);

  //#endregion

  //#region METHODS

  Future<WorkListResponse> listAll() async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work');
    final response = await httpGet(uri, headers);
    return processResponse(response, 200,
            () => WorkListResponse.fromJson(jsonDecode(response.body)))!
        as WorkListResponse;
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

  Future<ServiceClientResponse?> update(RequestWorkUpdate request) async {
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

  //#endregion
}
