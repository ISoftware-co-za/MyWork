import 'dart:convert';

import 'package:client_interfaces1/service/work.dart';
import 'package:http/http.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../execution/observability.dart';
import 'validation_problem_response.dart';

abstract class ServiceClientResponse {}

class ServiceClient {

  //#region CONSTRUCTION

  ServiceClient(String baseUrl, Observability observability)
      : _baseUrl = baseUrl,
        _observability = observability {
    _http = SentryHttpClient();
  }

  void dispose() {
    _http.close();
  }

  //#endregion

  //#region METHODS

  Future<ServiceClientResponse> workCreate(WorkCreateRequest request) async {
    Map<String, String> headers = _setupCommonHeaders();
    final uri = Uri.parse('$_baseUrl/work');
    final body = jsonEncode(request.toJson());
    final response = await _http.post(uri, headers: headers, body: body);
    return _processResponse(response, 201, () => WorkCreateResponse.fromJson(jsonDecode(response.body)))!;
  }

  Future<ServiceClientResponse?> workUpdate(WorkUpdateRequest request) async {
    Map<String, String> headers = _setupCommonHeaders();
    final uri = Uri.parse('$_baseUrl/work/${request.id}');
    final body = jsonEncode(request.toJson());
    final response = await _http.patch(uri, headers: headers, body: body);
    return _processResponse(response, 204, () => null);
  }

  Future<ServiceClientResponse?> workDelete(String id) async {
    Map<String, String> headers = _setupCommonHeaders();
    var uri = Uri.parse('$_baseUrl/work/$id');

    throw Exception('Test exception in client');

    final response = await _http.delete(uri, headers: headers);
    return _processResponse(response, 204, () => null);
  }

  //#endregion

  //#region PRIVATE METHODS

  Map<String, String> _setupCommonHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };
    _observability.startServiceCall(headers);
    return headers;
  }

  ServiceClientResponse? _processResponse(Response response, int successStatusCode, ServiceClientResponse? Function() function) {
    if (response.statusCode == successStatusCode) {
      return function();
    } else if (response.statusCode == 400) {
      return ValidationProblemResponse.fromJson(jsonDecode(response.body));
    } else {
      var problemResponse = jsonDecode(response.body);
      throw Exception(problemResponse['detail']);
    }
  }

  //#endregion

  //#region FIELDS

  final String _baseUrl;
  late final SentryHttpClient _http;
  final Observability _observability;

  //#endregion
}
