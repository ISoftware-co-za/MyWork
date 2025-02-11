import 'package:flutter/cupertino.dart';

import 'service_base.dart';

class ValidationProblemResponse extends ServiceClientResponse {
  final String type;
  final String title;
  final int statusCode;
  final Map<String, List<String>> errors;

  ValidationProblemResponse({required this.type, required this.title, required this.statusCode, required this.errors});

  factory ValidationProblemResponse.fromJson(Map<String, dynamic> json) {
    var propertyErrors = <String, List<String>>{};
    for (var key in json["errors"].keys) {
      propertyErrors[key] = List<String>.from(json["errors"][key]);
    }

    return ValidationProblemResponse(
      type: json['type'],
      title: json['title'],
      statusCode: json['status'],
      errors: propertyErrors
    );
  }
}
