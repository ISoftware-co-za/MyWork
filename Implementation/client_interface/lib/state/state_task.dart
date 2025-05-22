import 'state_activity_base.dart';
import '../model/properties.dart';

enum TaskState {
  idle,
  busy,
  paused,
  complete,
  cancelled
}

class StateTask extends PropertyOwner {
  late final StateProperty what;
  late final StateProperty why;
  late final StateProperty notes;
  late final StateProperty state;
  final List<StateActivityBase> activities = [];

  StateTask({
    String? what,
    String? why,
    String? notes,
    TaskState state = TaskState.idle}) {
    this.what = StateProperty(value: what);
    this.why = StateProperty(value: why);
    this.notes = StateProperty(value: notes);
    this.state = StateProperty(value: state);
  }
}