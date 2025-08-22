import '../../../model/person.dart';

class ListItemPerson {
  final Person person;

  ListItemPerson(this.person) {
    person.firstName.addListener(_onFirstNameChanged);
    person.lastName.addListener(_onLastNameChanged);
    _setLowercaseFirstName(person.firstName.value);
    _setLowercaseLastName(person.lastName.value);
  }

  bool doesMatch(String filterCriteria) {
    if (filterCriteria.isEmpty) {
      return true;
    }
    return _lowercaseFirstName.contains(filterCriteria) || _lowercaseLastName.contains(filterCriteria);
  }

  @override
  String toString() {
    return '${person.firstName.value} ${person.lastName.value}';
  }

  void _onFirstNameChanged() {
    _setLowercaseFirstName(person.firstName.value);
  }

  void _onLastNameChanged() {
    _setLowercaseLastName(person.lastName.value);
  }

  void _setLowercaseFirstName(String firstName) {
    _lowercaseFirstName = firstName.toLowerCase();
  }

  void _setLowercaseLastName(String lastName) {
    _lowercaseLastName = lastName.toLowerCase();
  }

  String _lowercaseFirstName = '';
  String _lowercaseLastName = '';
}