part of 'service_client_work.dart';

class CreateWorkRequest {
  final String name;
  final String type;
  final String reference;
  final String description;
  CreateWorkRequest(
      {required this.name, required this.type, required this.reference, required this.description});

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{'name': name};
    if (type.isNotEmpty) {
      json['type'] = type;
    }
    if (reference.isNotEmpty) {
      json['reference'] = reference;
    }
    if (description.isNotEmpty) {
      json['description'] = description;
    }
    return json;
  }
}

class CreateWorkResponse extends ServiceClientResponse {
  final String id;
  CreateWorkResponse({required this.id});

  factory CreateWorkResponse.fromJson(Map<String, dynamic> json) {
    return CreateWorkResponse(
      id: json['id'],
    );
  }
}
