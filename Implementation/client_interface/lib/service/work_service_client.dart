import 'dart:convert';

import 'package:client_interfaces1/service/service_base.dart';
import 'package:client_interfaces1/service/work_request_response.dart';

class WorkServiceClient extends ServiceClientBase{
  //#region CONSTRUCTION

  WorkServiceClient(super.baseUrl, super.observability);

  //#endregion

  //#region METHODS

  Future<ServiceClientResponse> create(WorkCreateRequest request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/work');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(response, 201, () => WorkCreateResponse.fromJson(jsonDecode(response.body)))!;
  }

  Future<ServiceClientResponse?> update(WorkUpdateRequest request) async {
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
