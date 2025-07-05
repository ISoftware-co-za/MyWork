part of 'service_client_work.dart';

class RequestCreateWork {
  final String name;
  final String type;
  final String reference;
  final String description;
  RequestCreateWork(
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

class ResponseWorkCreate extends ServiceClientResponse {
  final String id;
  ResponseWorkCreate({required this.id});

  factory ResponseWorkCreate.fromJson(Map<String, dynamic> json) {
    return ResponseWorkCreate(
      id: json['id'],
    );
  }
}
