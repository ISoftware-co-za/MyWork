import 'dart:convert';

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

}

class WorkCreateRequest {
  final String name;
  final String? type;
  final String? reference;
  WorkCreateRequest({required this.name, this.type, this.reference});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'reference': reference,
    };
  }
}

class WorkCreateResponse {
  final num id;
  WorkCreateResponse({required this.id});

  factory WorkCreateResponse.fromJson(Map<String, dynamic> json) {
    return WorkCreateResponse(
      id: json['id'],
    );
  }
}
