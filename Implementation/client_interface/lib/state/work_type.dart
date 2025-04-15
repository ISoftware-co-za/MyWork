import '../dialog_work/table_columns.dart';

class WorkType implements Comparable<WorkType>, lowercaseLabelProvider {
//#region PROPERTIES

  final String name;
  @override
  String get lowercaseName => _lowercaseName;

//#endregion

//#region CONSTRUCTION

  WorkType(this.name) : _lowercaseName = name.toLowerCase();

//#endregion

//#region METHODS

  @override
  String toString() {
    return name;
  }

  bool matchesFilter(String filter) {
    return _lowercaseName.contains(filter);
  }

  @override
  int compareTo(WorkType other) {
    return _lowercaseName.compareTo(other._lowercaseName);
  }

//#endregion

//#region METHODS

  final String _lowercaseName;

//#endregion
}
