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
    this.name = StateProperty(value: name, validators: [ValidatorRequired(invalidMessageTemplate : 'Name is required')]);
    this.reference = StateProperty(value: reference);
    this.description = StateProperty(value: description);
    this.type = StateProperty(value: type);
    this.tasks = tasks ?? [];
  }
}
