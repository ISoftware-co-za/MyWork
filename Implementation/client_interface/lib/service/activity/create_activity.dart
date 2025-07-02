import '../service_client_base.dart';

class RequestCreateActivity {
  final String what;
  final String? why;
  final String? notes;
  final DateTime? dueDate;

  RequestCreateActivity(
      {required this.what, this.why, this.notes, this.dueDate});

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{'what': what};
    if (why != null) {
      json['why'] = why;
    }
    if (notes != null) {
      json['notes'] = notes;
    }
    if (dueDate != null) {
      json['due_date'] = dueDate!.toIso8601String().substring(0, 10);
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