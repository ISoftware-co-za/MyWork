library service_client_user;

import 'dart:convert';
import 'dart:io';
import '../service_client_base.dart';

part 'login.dart';
part 'add_work_type.dart';

class ServiceClientUser extends ServiceClientBase {

  ServiceClientUser(super.baseUrl);

  Future<ResponseLogin> login(RequestLogin request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/users/login');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(response, HttpStatus.ok,
            () => ResponseLogin.fromJson(jsonDecode(response.body)))!
        as ResponseLogin;
  }

  Future<ServiceClientResponse> logout() async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/users/logout');
    final response = await httpPost(uri, headers, '');
    return processResponse(
        response, HttpStatus.ok, () => ServiceClientResponse())!;
  }

  Future<ServiceClientResponse> addWorkType(
      String userId, RequestAddWorkType request) async {
    Map<String, String> headers = setupCommonHeaders();
    final uri = generateUri('/users/workTypes');
    final body = jsonEncode(request.toJson());
    final response = await httpPost(uri, headers, body);
    return processResponse(
        response, HttpStatus.noContent, () => ServiceClientResponse())!;
  }
}
