import '../service_client_base.dart';

class RequestCreateActivity {
  final String what;
  final String state;
  final String? dueDate;
  final String? recipientId;
  final String? why;
  final String? notes;

  RequestCreateActivity(
      {required this.what, required this.state, this.dueDate, this.recipientId, this.why, this.notes});

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
    if (notes != null) {
      json['notes'] = notes;
    }
    return json;
  }
}

class ResponseCreateActivity extends ServiceClientResponse {
  final String id;
  ResponseCreateActivity({required this.id});

  factory ResponseCreateActivity.fromJson(Map<String, dynamic> json) {
    return ResponseCreateActivity(
      id: json['id'],
    );
  }
}