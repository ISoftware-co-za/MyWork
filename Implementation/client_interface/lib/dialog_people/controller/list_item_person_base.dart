import '../../model/person.dart';

class ListItemPersonBase {
  final Person person;
  String lowercaseFirstName = '';
  String lowercaseLastName = '';

  ListItemPersonBase(this.person) {
    person.firstName.addListener(_setLowercaseFirstName);
    person.lastName.addListener(_setLowercaseLastName);
    _setLowercaseFirstName();
    _setLowercaseLastName();
  }

  bool matchesFilter(String criteria) {
    if (criteria.isEmpty) {
      return true;
    }
    return lowercaseFirstName.contains(criteria) || lowercaseLastName.contains(criteria);
  }

  void _setLowercaseFirstName() {
    lowercaseFirstName = person.firstName.value.toLowerCase();
  }

  void _setLowercaseLastName() {
    lowercaseLastName = person.lastName.value.toLowerCase();
  }
}
