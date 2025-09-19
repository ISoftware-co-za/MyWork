import 'model_property.dart';
import 'model_property_change_context.dart';
import 'state_activity_base.dart';

enum TaskState {
  idle,
  busy,
  paused,
  complete,
  cancelled
}

class StateTask {
  late final ModelProperty what;
  late final ModelProperty why;
  late final ModelProperty notes;
  late final ModelProperty state;
  final List<StateActivityBase> activities = [];

  StateTask({
    required ModelPropertyChangeContext context,
    String? what,
    String? why,
    String? notes,
    TaskState state = TaskState.idle}) {
    this.what = ModelProperty(context: context, value: what);
    this.why = ModelProperty(context: context, value: why);
    this.notes = ModelProperty(context: context, value: notes);
    this.state = ModelProperty(context: context, value: state);
  }
}