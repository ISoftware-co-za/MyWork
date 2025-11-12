import '../service_client_base.dart';

class ListWorkActivitiesResponse implements ServiceClientResponse {
  final List<ActivityItem> items;

  ListWorkActivitiesResponse({required this.items});

  factory ListWorkActivitiesResponse.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<ActivityItem> itemsList = itemsJson
        .map((item) => ActivityItem.fromJson(item))
        .toList();
    return ListWorkActivitiesResponse(items: itemsList);
  }
}

class ActivityItem {
  final String id;
  final String what;
  final String state;
  final String? dueDate;
  final String? recipientId;
  final String? why;
  final String? how;
  final List<ActivityNoteItem>? notes;

  ActivityItem({
    required this.id,
    required this.what,
    required this.state,
    this.dueDate,
    this.recipientId,
    this.why,
    this.how,
    this.notes,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    List<ActivityNoteItem>? notesList;
    if (json['notes'] != null) {
      var notesJson = json['notes'] as List;
      notesList = notesJson
          .map((n) => ActivityNoteItem.fromJson(n as Map<String, dynamic>))
          .toList();
    }
    return ActivityItem(
      id: json['id'],
      what: json['what'],
      state: json['state'],
      dueDate: json['dueDate'],
      recipientId: json['recipientId'],
      why: json['why'],
      how: json['how'],
      notes: notesList,
    );
  }
}

class ActivityNoteItem {
  final String id;
  final String created;
  final String text;

  ActivityNoteItem(this.id, this.created, this.text);

  factory ActivityNoteItem.fromJson(Map<String, dynamic> json) {
    return ActivityNoteItem(
      json['id'] as String,
      json['created'] as String,
      json['text'] as String
    );
  }
}
