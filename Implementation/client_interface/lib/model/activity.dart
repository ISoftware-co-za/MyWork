import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../service/activity/create_activity.dart';
import '../service/activity/service_client_activity.dart';
import '../service/service_client_base.dart';
import '../service/update_entity.dart';
import 'properties.dart';
import 'property_changed_registry.dart';
import 'validator_base.dart';

enum ActivityState { idle, busy, done, paused, cancelled;

  static ActivityState fromString(String state) {
    switch (state.toLowerCase()) {
      case 'idle':
        return ActivityState.idle;
      case 'busy':
        return ActivityState.busy;
      case 'done':
        return ActivityState.done;
      case 'paused':
        return ActivityState.paused;
      case 'cancelled':
        return ActivityState.cancelled;
      default:
        throw ArgumentError('Unknown activity state: $state');
    }
  }
}

class Activity extends PropertyOwner {
  late String id;
  late final StateProperty<String> what;
  late final StateProperty<ActivityState> state;
  late final StateProperty<DateTime?> dueDate;
  late final StateProperty<String> why;
  late final StateProperty<String> notes;

  bool get isNew => id.isEmpty;

  Activity(
    this.id,
    String what,
    ActivityState state,
    String? why,
    String? notes,
    DateTime? dueDate,
  ) {
    _defineValidation(what, state, why, notes, dueDate);
    this.state.addListener(() {
      if (this.state.isChanged && this.state.notifyingProperty == 'value' && PropertyChangedRegistry.changeCount ==1 ) {
        debugPrint('Should save the activity ${this.what.value}');
      }
    });
  }

  Activity.create() {
    id = '';
    _defineValidation('', ActivityState.idle);
  }

  bool validate() {
    return what.validate() && state.validate() && dueDate.validate() && why.validate() && notes.validate();
  }

  Future save(String workID) async {
    var request = RequestCreateActivity(
        what: what.value,
        state: state.value.name,
        why: why.value.isEmpty ? null : why.value,
        notes: notes.value.isEmpty ? null : notes.value,
        dueDate: dueDate.value);

    var response = await _serviceClient.create(workID, request);
    if (response is ResponseCreateActivity) {
      id = response.id;
    } else if (response is ValidationProblemResponse) {
      invalidate(response.errors);
    }
  }

  Future update(String workID) async {
    List<UpdateEntityProperty> updatedProperties =listUpdatedProperties();
    if (updatedProperties.isNotEmpty) {
      var request =
      UpdateEntityRequest(id: id, updatedProperties: updatedProperties);
      var response = await _serviceClient.update(workID, request);
      if (response is ValidationProblemResponse) {
        invalidate(response.errors);
      }
    }
  }

  void _defineValidation(String what, ActivityState state, [String? why, String? notes, DateTime? dueDate]) {
    if (why == null) {
      why = '';
    }
    if (notes == null) {
      notes = '';
    }
    this.what = StateProperty(value: what, validators: [
      ValidatorRequired(invalidMessageTemplate: 'What is required'),
      ValidatorMaximumCharacters(maximumCharacters: 80, invalidMessageTemplate: 'What should be 80 characters or less')
    ]);
    this.state = StateProperty(value: state);
    this.dueDate = StateProperty(value: dueDate);
    this.why = StateProperty(value: why, validators: [
      ValidatorMaximumCharacters(maximumCharacters: 240, invalidMessageTemplate: 'Why should be 240 characters or less')
    ]);
    this.notes = StateProperty(value: notes, validators: [
      ValidatorMaximumCharacters(
          maximumCharacters: 240, invalidMessageTemplate: 'Notes should be 240 characters or less')
    ]);

    properties = {
      'What': this.what,
      'State': this.state,
      'DueDate': this.dueDate,
      'Why': this.why,
      'Notes': this.notes,
    };
  }

  ServiceClientActivity _serviceClient = GetIt.instance<ServiceClientActivity>();
}
