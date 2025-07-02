library service_client_base;

import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:sentry_flutter/sentry_flutter.dart';

part 'validation_problem_response.dart';

class ServiceClientBase {

  ServiceClientBase(String baseUrl) : _baseUrl = baseUrl {
    var wrappedClient = BrowserClient()..withCredentials = true;
    _http = SentryHttpClient(client: wrappedClient);
  }

  void dispose() {
    _http.close();
  }

  Uri generateUri(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Map<String, String> setupCommonHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json; charset=UTF-8'};
    return headers;
  }

  Future<Response> httpGet(Uri uri, Map<String, String> headers) async {
    return await _http.get(uri, headers: headers).timeout(const Duration(seconds: _httpTimeoutInSeconds));
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
      if (response.body.isNotEmpty) {
        throw Exception(response.body.split('"')[1]);
      } else {
        throw Exception('A problem occurred while processing the request (${response.statusCode}).');
      }
    } else {
      if (response.body.isNotEmpty) {
        var problemResponse = jsonDecode(response.body);
        throw Exception(problemResponse['detail']);
      } else {
        throw Exception(
            'An unknown problem occurred (${response.statusCode}). Support has been notified and is working on the problem.');
      }
    }
  }

  static const int _httpTimeoutInSeconds = 10;
  final String _baseUrl;
  late final SentryHttpClient _http;
}

class ServiceClientResponse {}
