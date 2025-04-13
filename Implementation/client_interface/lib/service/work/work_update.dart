part of 'service_client_work.dart';

class RequestWorkUpdate {
  final String id;
  final Iterable<WorkUpdatedProperty> updatedProperties;

  RequestWorkUpdate({required this.id, required this.updatedProperties});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updatedProperties': updatedProperties,
    };
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
