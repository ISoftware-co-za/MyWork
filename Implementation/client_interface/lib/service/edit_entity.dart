part of 'work/service_client_work.dart';

class EditEntityRequest {
  final String id;
  final Iterable<EditEntityProperty> updatedProperties;

  EditEntityRequest({required this.id, required this.updatedProperties});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updatedProperties': updatedProperties,
    };
  }
}

class EditEntityProperty {
  final String name;
  final dynamic value;
  EditEntityProperty({required this.name, this.value});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
