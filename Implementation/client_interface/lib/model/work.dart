import 'package:get_it/get_it.dart';

import '../service/service_client_base.dart';
import '../service/work/service_client_work.dart';
import '../state/state_task.dart';
import 'properties.dart';
import 'validator_base.dart';

class Work extends PropertyOwner {
  late String id;
  late final StateProperty<String> name;
  late final StateProperty<String> reference;
  late final StateProperty<String> description;
  late final StateProperty<String> type;
  late final StateProperty<bool> archived;
  late final List<StateTask> tasks;

  bool get isNew => id.isEmpty;

  Work.create() {
    id = '';
    _defineValidation('', '', '', false, '');
  }

  Work({required this.id,
    String? name,
    String? reference,
    String? description,
    String? type,
    bool? archived}) {
    _defineValidation(name, reference, description, archived, type);
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

  Future define() async {
    var request = RequestCreateWork(
        name: name.value!,
        type: type.value,
        reference: reference.value,
        description: description.value);
    var response = await GetIt.instance<ServiceClientWork>().create(request);
    if (response is ResponseWorkCreate) {
      id = response.id;
    } else if (response is ValidationProblemResponse) {
      invalidate(response.errors);
    }
  }

  Future update() async {
    var updatedProperties = <WorkUpdatedProperty>[];
    if (name.isChanged) {
      updatedProperties
          .add(WorkUpdatedProperty(name: 'Name', value: name.value));
    }
    if (type.isChanged) {
      updatedProperties
          .add(WorkUpdatedProperty(name: 'Type', value: type.value));
    }
    if (reference.isChanged) {
      updatedProperties.add(
          WorkUpdatedProperty(name: 'Reference', value: reference.value));
    }
    if (description.isChanged) {
      updatedProperties.add(WorkUpdatedProperty(
          name: 'Description', value: description.value));
    }
    if (updatedProperties.isNotEmpty) {
      var request =
      RequestWorkUpdate(id: id!, updatedProperties: updatedProperties);
      var response = await _serviceClient.update(request);
      /*
      var responseProcess =
      ResponseProcessFactory.createWorkProcessResponse(response, this);
      */
      if (response is ValidationProblemResponse) {
        invalidate(response.errors);
      }
    }
  }

  Future delete() async {
    await _serviceClient.delete(id);
  }

  void _defineValidation(String? name, String? reference, String? description, bool? archived, String? type) {
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
    this.type = StateProperty<String>(
        value: type,
        validators: [
          ValidatorMaximumCharacters(
              maximumCharacters: 40,
              invalidMessageTemplate: 'Type should be 40 characters or less')
        ]);
    this.tasks = [];
    _properties = {
      'name': this.name,
      'reference': this.reference,
      'description': this.description,
      'type': this.type
    };
  }

  late final Map<String, StateProperty> _properties;
  final ServiceClientWork _serviceClient = GetIt.instance<ServiceClientWork>();
}

//----------------------------------------------------------------------------------------------------------------------
