library service_client_base;

import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'dart:convert';

part 'validation_problem_response.dart';

class ServiceClientBase {
  //#region CONSTRUCTION

  ServiceClientBase(String baseUrl) : _baseUrl = baseUrl {
    _browserClient = BrowserClient()..withCredentials = true;
    // _http = SentryHttpClient();
  }

  void dispose() {
    // _http.close();
  }

  //#endregion

  //#region METHODS

  Uri generateUri(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Map<String, String> setupCommonHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    };
    return headers;
  }

  Future<Response> httpGet(Uri uri, Map<String, String> headers) async {
    return await _browserClient
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: _httpTimeoutInSeconds));
  }

  Future<Response> httpPost(
      Uri uri, Map<String, String> headers, String body) async {
    return await _browserClient
        .post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: _httpTimeoutInSeconds));
  }

  Future<Response> httpPatch(
      Uri uri, Map<String, String> headers, String body) async {
    return await _browserClient
        .patch(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: _httpTimeoutInSeconds));
  }

  Future<Response> httpDelete(Uri uri, Map<String, String> headers) async {
    return await _browserClient
        .delete(uri, headers: headers)
        .timeout(const Duration(seconds: _httpTimeoutInSeconds));
  }

  ServiceClientResponse? processResponse(Response response,
      int successStatusCode, ServiceClientResponse? Function() function) {
    if (response.statusCode == successStatusCode) {
      return function();
    } else if (response.statusCode == 400) {
      return ValidationProblemResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('Credentials are invalid (${response.statusCode}).');
    } else if (response.statusCode == 404 || response.statusCode == 405) {
      throw Exception(
          'A problem occurred while processing the request (${response.statusCode}).');
    } else {
      if (response.body.isEmpty) {
        throw Exception(
            'An unknown problem occurred (${response.statusCode}). Support has been notified and is working on the problem.');
      }
      var problemResponse = jsonDecode(response.body);
      throw Exception(problemResponse['detail']);
    }
  }

  //#endregion

  //#region FIELDS

  static const int _httpTimeoutInSeconds = 10;
  final String _baseUrl;
  // late final SentryHttpClient _http;
  late final BrowserClient _browserClient;

  //#endregion
}

class ServiceClientResponse {}
