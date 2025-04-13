import 'state_task.dart';
import 'properties.dart';
import 'work_type.dart';

//----------------------------------------------------------------------------------------------------------------------

class WorkSummary {
  final String id;
  final String name;
  final String reference;
  final String type;
  final bool archived;

  WorkSummary(
      {required this.id,
      required this.name,
      required this.reference,
      required this.type,
      required this.archived})
      : _lowercaseName = name.toLowerCase(),
        _lowercaseReference = reference.toLowerCase(),
        _lowercaseType = type.toLowerCase();

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
    if (archivedFilter != null && archivedFilter != archived) {
      return false;
    }
    return true;
  }

  final String _lowercaseName;
  final String _lowercaseReference;
  final String _lowercaseType;
}

//----------------------------------------------------------------------------------------------------------------------

class StateWork extends PropertyOwner {
  String? id;
  late final StateProperty<String> name;
  late final StateProperty<String> reference;
  late final StateProperty<String> description;
  late final StateProperty<WorkType> type;
  late final StateProperty<bool> archived;
  late final List<StateTask> tasks;

  StateWork(
      {String? id,
      String? name,
      String? reference,
      String? description,
      String? type,
      bool? archived,
      List<StateTask>? tasks}) {
    this.name = StateProperty(value: name, validators: [
      ValidatorRequired(invalidMessageTemplate: 'Name is required'),
      ValidatorMaximumCharacters(
          maximumCharacters: 80,
          invalidMessageTemplate: 'Name should be 80 characters or less')
    ]);
    this.reference = StateProperty(value: reference, validators: [
      ValidatorMaximumCharacters(
          maximumCharacters: 40,
          invalidMessageTemplate: 'Reference should be 40 characters or less')
    ]);
    this.description = StateProperty(value: description);
    this.archived = StateProperty(value: archived ?? false);
    this.type = StateProperty<WorkType>(
        value: type == null ? null : WorkType(type),
        validators: [
          ValidatorMaximumCharacters(
              maximumCharacters: 40,
              invalidMessageTemplate: 'Type should be 40 characters or less')
        ]);
    this.tasks = tasks ?? [];
    _properties = {
      'name': this.name,
      'reference': this.reference,
      'description': this.description,
      'type': this.type
    };
  }

  bool validate() {
    return name.validate() &&
        reference.validate() &&
        description.validate() &&
        type.validate();
  }

  void invalidate(Map<String, List<String>> errors) {
    for (var entry in errors.entries) {
      assert(_properties[entry.key] != null);
      _properties[entry.key]?.invalidate(message: entry.value.first);
    }
  }

  late final Map<String, StateProperty> _properties;
}

//----------------------------------------------------------------------------------------------------------------------
