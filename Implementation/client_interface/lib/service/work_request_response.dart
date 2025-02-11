import 'package:client_interfaces1/state/state_work_type.dart';

import 'service_base.dart';

class WorkCreateRequest {
  final String name;
  final StateWorkType? type;
  final String? reference;
  final String? description;
  WorkCreateRequest({required this.name, this.type, this.reference, this.description});

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{'name': name};
    if (type != null) {
      json['type'] = type!.name;
    }
    if (reference != null) {
      json['reference'] = reference;
    }
    if (description != null) {
      json['description'] = description;
    }
    return json;
  }
}

class WorkCreateResponse extends ServiceClientResponse {
  final String id;
  WorkCreateResponse({required this.id});

  factory WorkCreateResponse.fromJson(Map<String, dynamic> json) {
    return WorkCreateResponse(
      id: json['id'],
    );
  }
}

class WorkUpdatedProperty {
  final String name;
  final dynamic value;
  WorkUpdatedProperty({required this.name, this.value});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class WorkUpdateRequest {
  final String id;
  final Iterable<WorkUpdatedProperty> updatedProperties;

  WorkUpdateRequest({required this.id, required this.updatedProperties});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updatedProperties': updatedProperties,
    };
  }
}