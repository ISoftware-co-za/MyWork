import '../service_client_base.dart';

class CreateActivityRequest {
  final String what;
  final String state;
  final String? dueDate;
  final String? recipientId;
  final String? why;
  final String? how;

  CreateActivityRequest(
      {required this.what, required this.state, this.dueDate, this.recipientId, this.why, this.how});

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
    return json;
  }
}

class CreateActivityResponse extends ServiceClientResponse {
  final String id;
  CreateActivityResponse({required this.id});

  factory CreateActivityResponse.fromJson(Map<String, dynamic> json) {
    return CreateActivityResponse(
      id: json['id'],
    );
  }
}