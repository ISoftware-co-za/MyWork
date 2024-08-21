import 'state_task.dart';
import '../ui%20toolkit/properties.dart';

class StateWork extends PropertyOwner {
  late final StateProperty name;
  late final StateProperty reference;
  late final StateProperty description;
  late final StateProperty type;
  late final List<StateTask> tasks;

  StateWork({String? name, String? reference, String? description, String? type, List<StateTask>? tasks}) {
    this.name = StateProperty(value: name, validators: [ValidatorRequired(invalidTemplateMessage: 'Name is required')]);
    this.reference = StateProperty(value: reference);
    this.description = StateProperty(value: description);
    this.type = StateProperty(value: type);
    this.tasks = tasks ?? [];
  }
}
