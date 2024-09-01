import '../../ui toolkit/properties.dart';

class ListItemDetail {
  final String label;
  final StateProperty property;
  final ListItemDetailEditor editorType;

  ListItemDetail({required this.label, required this.property, required this.editorType});
}

enum ListItemDetailEditor {
  text,
  autocomplete,
  parchment,
}