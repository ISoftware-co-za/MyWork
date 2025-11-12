import '../service_client_base.dart';

class CreateActivityRequest {
  final String what;
  final String state;
  final String? dueDate;
  final String? recipientId;
  final String? why;
  final String? how;
  final List<CreateActivityNote>? notes;

  CreateActivityRequest(
      {required this.what, required this.state, this.dueDate, this.recipientId, this.why, this.how, this.notes});

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{'what': what, 'state': state};
    if (dueDate != null) {
      json['dueDate'] =  dueDate;
    }
    if (recipientId != null) {
      json['recipientId'] =  recipientId;
    }
    if (why != null) {
      json['why'] = why;
    }
    if (how != null) {
      json['how'] = how;
    }
    if (notes != null && notes!.length > 0) {
      json['notes'] = notes!.map((n) => n.toJson()).toList();
    }
    return json;
  }
}

class CreateActivityNote {
  final String created;
  final String text;

  CreateActivityNote(this.created, this.text);

  Map<String, dynamic> toJson() {
    return {
      'created': created,
      'text': text,
    };
  }
}

class CreateActivityResponse extends ServiceClientResponse {
  final String id;
  final List<String>? noteIds;
  CreateActivityResponse({required this.id, required this.noteIds});

  factory CreateActivityResponse.fromJson(Map<String, dynamic> json) {
    List<String>? nodeIds;
    if (json.containsKey('noteIds')) {
      List<dynamic> jsArray = json['noteIds'];
      nodeIds = List<String>.generate(jsArray.length, (i) => jsArray[i].toString());
    }
    return CreateActivityResponse(
      id: json['id'],
        noteIds: nodeIds);
  }
}

