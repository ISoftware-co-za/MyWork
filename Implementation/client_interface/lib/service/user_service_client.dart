import 'dart:convert';
import 'dart:io';

import 'package:client_interfaces1/service/service_base.dart';

import 'user_request_response.dart';

class UserServiceClient extends ServiceClientBase {
  //#region CONSTRUCTION

  UserServiceClient(super.baseUrl, super.observability);

  //#endregion

  //#region METHODS

  //--------------------------------------------------------------------------------------------------------------------

  Future<ServiceClientResponse> login(LoginRequest request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/users/login');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(response, HttpStatus.ok, () => LoginResponse.fromJson(jsonDecode(response.body)))!;
  }

  //--------------------------------------------------------------------------------------------------------------------

  Future<ServiceClientResponse> addWorkType(String userId, AddWorkTypeRequest request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/users/$userId/workTypes');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(response, HttpStatus.noContent, () => ServiceClientResponse())!;
  }

  //--------------------------------------------------------------------------------------------------------------------

  //#endregion
}
