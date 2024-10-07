class WorkCreateRequest {
  final String name;
  final String? type;
  final String? reference;
  final String? description;
  WorkCreateRequest({required this.name, this.type, this.reference, this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'reference': reference,
      'description': description
    };
  }
}

class WorkCreateResponse {
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