import 'package:client_interfaces1/model/properties.dart';
import 'package:client_interfaces1/service/activity/service_client_activity.dart';
import 'package:get_it/get_it.dart';

import '../service/activity/create_activity.dart';
import '../service/service_client_base.dart';
import 'validator_base.dart';

enum ActivityState {
  idle,
  busy,
  done,
  paused,
  cancelled
}

class Activity extends PropertyOwner {
  late String id;
  late final StateProperty<String> what;
  late final StateProperty<ActivityState> state;
  late final StateProperty<DateTime?> dueDate;
  late final StateProperty<String> why;
  late final StateProperty<String> notes;

  bool get isNew => id.isEmpty;

  bool validate() {
    return what.validate() &&
        state.validate() &&
        dueDate.validate() &&
        why.validate() &&
        notes.validate();
  }

  Activity.create() {
    id = '';
    _defineValidation('', ActivityState.idle, '', '', null);
  }

  Future save(String workID) async {
    var request = RequestCreateActivity(
        what: what.value,
        state: state.value.name,
        why: why.value.isEmpty ? null : why.value,
        notes: notes.value.isEmpty ? null : notes.value,
        dueDate: dueDate.value);

    var response = await GetIt.instance<ServiceClientActivity>().create(workID, request);
    if (response is ResponseCreateActivity) {
      id = response.id;
    } else if (response is ValidationProblemResponse) {
      invalidate(response.errors);
    }
  }

  void _defineValidation(String what, ActivityState state, String why, String notes, DateTime? dueDate) {
    this.what = StateProperty(value: what, validators: [
      ValidatorRequired(invalidMessageTemplate: 'What is required'),
      ValidatorMaximumCharacters(
          maximumCharacters: 80,
          invalidMessageTemplate: 'What should be 80 characters or less')
    ]);
    this.state = StateProperty(value: state);
    this.dueDate = StateProperty(value: dueDate);
    this.why = StateProperty(value: why, validators: [
      ValidatorMaximumCharacters(
          maximumCharacters: 240,
          invalidMessageTemplate: 'Why should be 240 characters or less')
    ]);
    this.notes = StateProperty(value: notes, validators: [
      ValidatorMaximumCharacters(
          maximumCharacters: 240,
          invalidMessageTemplate: 'Notes should be 240 characters or less')
    ]);

    properties = {
      'what': this.what,
      'state': this.state,
      'dueDate': this.dueDate,
      'why': this.why,
      'notes': this.notes,
    };
  }
}

