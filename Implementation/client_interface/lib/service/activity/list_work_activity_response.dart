import '../service_client_base.dart';

class WorkActivityListResponse implements ServiceClientResponse {
  final List<ActivityItem> items;

  WorkActivityListResponse({required this.items});

  factory WorkActivityListResponse.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<ActivityItem> itemsList = itemsJson.map((item) => ActivityItem.fromJson(item)).toList();
    return WorkActivityListResponse(items: itemsList);
  }
}

class ActivityItem {
  final String id;
  final String what;
  final String state;
  final String? why;
  final String? notes;
  final DateTime? dueDate;

  ActivityItem({
    required this.id,
    required this.what,
    required this.state,
    this.why,
    this.notes,
    this.dueDate,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'],
      what: json['what'],
      state: json['state'],
      why: json['why'],
      notes: json['notes'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }
}