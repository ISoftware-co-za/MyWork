part of 'service_client_work.dart';

class WorkListResponse extends ServiceClientResponse {
  final List<WorkListItem> items;

  WorkListResponse.ResponseWorkList({required this.items});

  factory WorkListResponse.fromJson(Map<String, dynamic> json) {
    return WorkListResponse.ResponseWorkList(
        items: (json['items'] as List)
            .map((e) => WorkListItem.fromJson(e))
            .toList());
  }
}

class WorkListItem {
  final String id;
  final String name;
  final String? reference;
  final String? type;
  final bool archived;

  WorkListItem(
      {required this.id,
      required this.name,
      this.reference,
      this.type,
      required this.archived});

  factory WorkListItem.fromJson(Map<String, dynamic> json) {
    return WorkListItem(
        id: json['id'],
        name: json['name'],
        reference: json['reference'],
        type: json['type'],
        archived: json['archived']);
  }
}
