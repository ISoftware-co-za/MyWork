import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:http/http.dart' as http;


import '../execution/observability.dart';
import 'validation_problem_response.dart';

class ServiceClientBase {
  //#region CONSTRUCTION

  ServiceClientBase(String baseUrl, Observability observability)
      : _baseUrl = baseUrl,
        _observability = observability {
    _http = SentryHttpClient();
  }

  void dispose() {
    _http.close();
  }

  //#endregion

  //#region METHODS

  Uri generateUri(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Map<String, String> setupCommonHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
    // _observability.startServiceCall(headers);
    return headers;
  }

  Future<Response> httpPost(Uri uri, Map<String, String> headers, String body) async {
    return await _http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: _httpTimeoutInSeconds));
  }

  Future<Response> httpPatch(Uri uri, Map<String, String> headers, String body) async {
    return await _http.patch(uri, headers: headers, body: body).timeout(const Duration(seconds: _httpTimeoutInSeconds));
  }

  Future<Response> httpDelete(Uri uri, Map<String, String> headers) async {
    return await _http.delete(uri, headers: headers).timeout(const Duration(seconds: _httpTimeoutInSeconds));
  }

  ServiceClientResponse? processResponse(
      Response response, int successStatusCode, ServiceClientResponse? Function() function) {
    if (response.statusCode == successStatusCode) {
      return function();
    } else if (response.statusCode == 400) {
      return ValidationProblemResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('Credentials are invalid (${response.statusCode}).');
    } else if (response.statusCode == 404 || response.statusCode == 405) {
      throw Exception('A problem occurred while processing the request (${response.statusCode}).');
    } else {
      var problemResponse = jsonDecode(response.body);
      throw Exception(problemResponse['detail']);
    }
  }

  //#endregion

  //#region FIELDS

  static const int _httpTimeoutInSeconds = 10;
  final String _baseUrl;
  late final SentryHttpClient _http;
  final Observability _observability;

  //#endregion
}

class ServiceClientResponse {}
