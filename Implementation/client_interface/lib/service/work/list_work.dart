part of 'service_client_work.dart';

class ListWorkResponse extends ServiceClientResponse {
  final List<WorkItem> items;

  ListWorkResponse.ResponseWorkList({required this.items});

  factory ListWorkResponse.fromJson(Map<String, dynamic> json) {
    return ListWorkResponse.ResponseWorkList(
        items: (json['items'] as List)
            .map((e) => WorkItem.fromJson(e))
            .toList());
  }
}

class WorkItem {
  final String id;
  final String name;
  final String? reference;
  final String? type;
  final bool archived;

  WorkItem(
      {required this.id,
      required this.name,
      this.reference,
      this.type,
      required this.archived});

  factory WorkItem.fromJson(Map<String, dynamic> json) {
    return WorkItem(
        id: json['id'],
        name: json['name'],
        reference: json['reference'],
        type: json['type'],
        archived: json['archived']);
  }
}
