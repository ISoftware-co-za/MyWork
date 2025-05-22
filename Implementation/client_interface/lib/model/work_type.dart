
class WorkType implements Comparable<WorkType> {
  final String name;
  String get lowercaseName => _lowercaseName;

  WorkType(this.name) : _lowercaseName = name.toLowerCase();

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

  final String _lowercaseName;
}
