import '../service_client_base.dart';

class RequestCreateActivity {
  final String what;
  final String state;
  final String? why;
  final String? notes;
  final String? dueDate;

  RequestCreateActivity(
      {required this.what, required this.state, this.why, this.notes, this.dueDate});

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{'what': what, 'state': state};
    if (why != null) {
      json['why'] = why;
    }
    if (notes != null) {
      json['notes'] = notes;
    }
    if (dueDate != null) {
      json['dueDate'] =  dueDate;
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