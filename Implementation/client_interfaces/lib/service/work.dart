class Work extends WorkData {
  WorkKey key;
  WorkData data;

  Work({required this.key, required this.data})
      : super(
            name: data.name,
            classification: data.classification,
            reference: data.reference,
            description: data.description);

  @override
  Map<String, dynamic> toJson() {
    return {
      'key': key.toJson(),
      'data': data.toJson(),
    };
  }
}

class WorkKey {
  final int id;

  WorkKey({required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

class WorkData {
  String name;
  String? classification;
  String? reference;
  String? description;

  WorkData(
      {required this.name,
      this.classification,
      this.reference,
      this.description});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'classification': classification,
      'reference': reference,
      'description': description,
    };
  }
}

class WorkUpdate {
  WorkKey key;
  Map<String, dynamic> updatedProperties = {};

  WorkUpdate({required this.key, required this.updatedProperties});
}

/*
Create
POST WorkData -> WorkKey

Update
PUT WorkUpdate -> void (updatedProperties specifies the values of the properties updated.

Delete
DELETE WorkKey -> void

 */
