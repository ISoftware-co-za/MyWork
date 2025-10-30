import '../service_client_base.dart';

class ListWorkActivitiesResponse implements ServiceClientResponse {
  final List<ActivityItem> items;

  ListWorkActivitiesResponse({required this.items});

  factory ListWorkActivitiesResponse.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<ActivityItem> itemsList = itemsJson.map((item) => ActivityItem.fromJson(item)).toList();
    return ListWorkActivitiesResponse(items: itemsList);
  }
}

class ActivityItem {
  final String id;
  final String what;
  final String state;
  final DateTime? dueDate;
  final String? recipientId;
  final String? why;
  final String? how;

  ActivityItem({
    required this.id,
    required this.what,
    required this.state,
    this.dueDate,
    this.recipientId,
    this.why,
    this.how,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'],
      what: json['what'],
      state: json['state'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      recipientId: json['recipientId'],
      why: json['why'],
      how: json['how']
    );
  }
}