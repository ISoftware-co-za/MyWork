class UpdateEntityRequest {
  final String id;
  final Iterable<UpdateEntityProperty> updatedProperties;

  UpdateEntityRequest({required this.id, required this.updatedProperties});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updatedProperties': updatedProperties,
    };
  }
}

class UpdateEntityProperty {
  final String name;
  final dynamic value;
  UpdateEntityProperty({required this.name, this.value});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}
