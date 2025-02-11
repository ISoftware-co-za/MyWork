class StateWorkType implements Comparable<StateWorkType> {
  final String name;
  final String lowerCaseName;

  StateWorkType(this.name) : lowerCaseName = name.toLowerCase();

  bool matchesFilter(String filter) {
      return lowerCaseName.contains(filter.toLowerCase());
  }

  @override
  String toString() {
    return name;
  }

  @override
  int compareTo(StateWorkType other) {
    return lowerCaseName.compareTo(other.lowerCaseName);
  }
}