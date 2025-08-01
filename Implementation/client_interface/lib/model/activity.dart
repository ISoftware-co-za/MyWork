import 'package:client_interfaces1/model/data_conversion.dart';
import 'package:get_it/get_it.dart';

import '../service/activity/create_activity.dart';
import '../service/activity/service_client_activity.dart';
import '../service/service_client_base.dart';
import '../service/update_entity.dart';
import 'model_property.dart';
import 'model_property_context.dart';
import 'validator_base.dart';

enum ActivityState {
  idle,
  busy,
  done,
  paused,
  cancelled;

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
  late String workId;
  late final ModelProperty<String> what;
  late final ModelProperty<ActivityState> state;
  late final ModelProperty<DateTime?> dueDate;
  late final ModelProperty<String> why;
  late final ModelProperty<String> notes;

  bool get isNew => id.isEmpty;

  Activity(
    ModelPropertyContext context,
    this.id,
    this.workId,
    String what,
    ActivityState state,
    String? why,
    String? notes,
    DateTime? dueDate,
  ) : super(context) {
    _context = context;
    _initialiseInstance(what, state, why, notes, dueDate);
  }

  Activity.create(ModelPropertyContext context, String workId) : super(context) {
    _context = context;
    id = '';
    this.workId = workId;
    _initialiseInstance('', ActivityState.idle);
  }

  bool validate() {
    return what.validate() &&
        state.validate() &&
        dueDate.validate() &&
        why.validate() &&
        notes.validate();
  }

  Future save() async {
    var request = RequestCreateActivity(
      what: what.value,
      state: state.value.name,
      why: why.value.isEmpty ? null : why.value,
      notes: notes.value.isEmpty ? null : notes.value,
      dueDate: DataConversionModelToService.dateTimeToDateString(dueDate.value),
    );

    var response = await _serviceClient.create(workId, request);
    if (response is ResponseCreateActivity) {
      id = response.id;
    } else if (response is ValidationProblemResponse) {
      invalidate(response.errors);
    }
  }

  Future update() async {
    List<UpdateEntityProperty> updatedProperties = listUpdatedProperties();
    if (updatedProperties.isNotEmpty) {
      var request = UpdateEntityRequest(
        id: id,
        updatedProperties: updatedProperties,
      );
      var response = await _serviceClient.update(workId, request);
      if (response is ValidationProblemResponse) {
        invalidate(response.errors);
      }
    }
  }

  Future delete() async {
    await _serviceClient.delete(workId, id);
  }

  void _initialiseInstance(
    String what,
    ActivityState state, [
    String? why,
    String? notes,
    DateTime? dueDate,
  ]) {
    if (why == null) {
      why = '';
    }
    if (notes == null) {
      notes = '';
    }
    this.what = ModelProperty(
      context: _context,
      value: what,
      validators: [
        ValidatorRequired(invalidMessageTemplate: 'What is required'),
        ValidatorMaximumCharacters(
          maximumCharacters: 80,
          invalidMessageTemplate: 'What should be 80 characters or less',
        ),
      ],
    );
    this.state = ModelProperty(context: _context, value: state);
    this.dueDate = ModelProperty(context: _context, value: dueDate);
    this.why = ModelProperty(
      context: _context,
      value: why,
      validators: [
        ValidatorMaximumCharacters(
          maximumCharacters: 240,
          invalidMessageTemplate: 'Why should be 240 characters or less',
        ),
      ],
    );
    this.notes = ModelProperty(
      context: _context,
      value: notes,
      validators: [
        ValidatorMaximumCharacters(
          maximumCharacters: 240,
          invalidMessageTemplate: 'Notes should be 240 characters or less',
        ),
      ],
    );

    properties = {
      'what': this.what,
      'state': this.state,
      'dueDate': this.dueDate,
      'why': this.why,
      'notes': this.notes,
    };
  }

  late final ModelPropertyContext _context;
  ServiceClientActivity _serviceClient =
      GetIt.instance<ServiceClientActivity>();
}
