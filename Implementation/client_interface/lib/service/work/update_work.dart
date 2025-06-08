part of 'service_client_work.dart';

class RequestUpdateWork {
  final String id;
  final Iterable<UpdateWorkProperty> updatedProperties;

  RequestUpdateWork({required this.id, required this.updatedProperties});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updatedProperties': updatedProperties,
    };
  }
}

class UpdateWorkProperty {
  final String name;
  final dynamic value;
  UpdateWorkProperty({required this.name, this.value});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
