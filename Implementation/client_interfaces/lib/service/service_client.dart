import 'dart:convert';

import 'package:client_interfaces1/service/work.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ServiceClient {
  ServiceClient(String baseUrl) : _baseUrl = baseUrl;

  final String _baseUrl;

  Future<WorkCreateResponse> workCreate(WorkCreateRequest request) async {
    var uri = Uri.parse('$_baseUrl/work');
    var body = jsonEncode(request.toJson());
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body
    );

    if (response.statusCode == 200) {
      return WorkCreateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create work');
    }
  }

  Future workUpdate(WorkUpdateRequest request) async {
    var uri = Uri.parse('$_baseUrl/work');
    var body = jsonEncode(request.toJson());
    final response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body
    );

    if (response.statusCode != 200) {
      debugPrint(response.body);
      throw Exception('Failed to update work');
    }
  }

  Future workDelete(String id) async {
    var uri = Uri.parse('$_baseUrl/work/$id');
    final response = await http.delete(
        uri
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete work');
    }
  }
}
