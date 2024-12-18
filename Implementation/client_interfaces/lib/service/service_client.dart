import 'dart:convert';

import 'package:client_interfaces1/service/work.dart';
import 'package:http/http.dart' as http;

import 'validation_problem_response.dart';

abstract class ServiceClientResponse {
}

class ServiceClient {
  ServiceClient(String baseUrl) : _baseUrl = baseUrl;

  final String _baseUrl;

  Future<ServiceClientResponse> workCreate(WorkCreateRequest request) async {
    var uri = Uri.parse('$_baseUrl/work');
    var body = jsonEncode(request.toJson());
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body
    );

    if (response.statusCode == 201) {
      return WorkCreateResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      return ValidationProblemResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Unable to create work. (${response.statusCode})');
    }
  }

  Future<ServiceClientResponse?> workUpdate(WorkUpdateRequest request) async {
    var uri = Uri.parse('$_baseUrl/work/${request.id}');
    var body = jsonEncode(request.toJson());
    final response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body
    );

    if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      return ValidationProblemResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update work');
    }
  }

  Future<ServiceClientResponse?> workDelete(String id) async {
    var uri = Uri.parse('$_baseUrl/work/$id');
    final response = await http.delete(
        uri
    );
    if (response.statusCode == 204) {
      return null;
    }
    throw Exception('Failed to delete work');
  }
}
