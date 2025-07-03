import 'package:client_interfaces1/model/work.dart';

class ListItemWork {

  final Work work;

  ListItemWork(this.work)
      : _lowercaseName = work.name.valueAsString.toLowerCase(),
        _lowercaseReference = work.reference.valueAsString.toLowerCase(),
        _lowercaseType = work.type.valueAsString.toLowerCase();

  bool isMatch(String nameFilter, String referenceFilter,
      List<String> typeFilter, bool? archivedFilter) {
    if (nameFilter.isNotEmpty && !_lowercaseName.contains(nameFilter)) {
      return false;
    }
    if (referenceFilter.isNotEmpty &&
        !_lowercaseReference.contains(referenceFilter)) {
      return false;
    }
    if (typeFilter.isNotEmpty &&
        !typeFilter.any((element) => _lowercaseType == element)) {
      return false;
    }
    if (archivedFilter != null && archivedFilter != work.archived.value) {
      return false;
    }
    return true;
  }

  final String _lowercaseName;
  final String _lowercaseReference;
  final String _lowercaseType;

}