import 'state_task.dart';
import 'properties.dart';

class StateWork extends PropertyOwner {
  String? id;
  late final StateProperty name;
  late final StateProperty reference;
  late final StateProperty description;
  late final StateProperty type;
  late final List<StateTask> tasks;

  StateWork({String? id, String? name, String? reference, String? description, String? type, List<StateTask>? tasks}) {
    this.name = StateProperty(value: name, validators: [ValidatorRequired(invalidMessageTemplate : 'Name is required'), ValidatorMaximumCharacters(maximumCharacters: 80, invalidMessageTemplate : 'Name should be 80 characters or less')]);
    this.reference = StateProperty(value: reference, validators: [ValidatorMaximumCharacters(maximumCharacters: 40, invalidMessageTemplate : 'Reference should be 40 characters or less')]);
    this.description = StateProperty(value: description);
    this.type = StateProperty(value: type, validators: [ValidatorMaximumCharacters(maximumCharacters: 40, invalidMessageTemplate : 'Type should be 40 characters or less')]);
    this.tasks = tasks ?? [];
    _properties = {
      'name': this.name,
      'reference': this.reference,
      'description': this.description,
      'type': this.type
    };
  }

  bool validate() {
    return name.validate() && reference.validate() && description.validate() && type.validate();
  }

  void invalidate(Map<String, List<String>> errors) {
    for (var entry in errors.entries) {
      assert(_properties[entry.key] != null);
      _properties[entry.key]?.invalidate(message: entry.value.first);
    }
  }

  late final Map<String,StateProperty> _properties;
}
