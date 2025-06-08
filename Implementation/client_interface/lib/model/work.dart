import 'package:get_it/get_it.dart';

import '../service/service_client_base.dart';
import '../service/work/service_client_work.dart';
import '../service/work/load_work_details.dart';
import 'state_task.dart';
import 'data_conversion_service_to_model.dart';
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
    _defineValidation('', '', false, '');
  }

  Work({required this.id,
    String? name,
    String? reference,
    String? type,
    bool? archived}) {
    _defineValidation(name, reference, archived, type);
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

  Future loadDetails() async {
    if (!_isLoaded) {
      WorkDetailsResponse response = await _serviceClient.loadDetails(id);
      description.setValue(DataConversionServiceToModel.nullToEmptyString(response.details.description));
      _isLoaded = true;
    }
  }

  Future update() async {
    var updatedProperties = <UpdateWorkProperty>[];
    if (name.isChanged) {
      updatedProperties
          .add(UpdateWorkProperty(name: 'Name', value: name.value));
    }
    if (type.isChanged) {
      updatedProperties
          .add(UpdateWorkProperty(name: 'Type', value: type.value));
    }
    if (reference.isChanged) {
      updatedProperties.add(
          UpdateWorkProperty(name: 'Reference', value: reference.value));
    }
    if (description.isChanged) {
      updatedProperties.add(UpdateWorkProperty(
          name: 'Description', value: description.value));
    }
    if (updatedProperties.isNotEmpty) {
      var request =
      RequestUpdateWork(id: id, updatedProperties: updatedProperties);
      var response = await _serviceClient.update(request);
      if (response is ValidationProblemResponse) {
        invalidate(response.errors);
      }
    }
  }

  Future delete() async {
    await _serviceClient.delete(id);
  }

  void _defineValidation(String? name, String? reference, bool? archived, String? type) {
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
    this.description = StateProperty(value: null);
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
  bool _isLoaded = false;
}

//----------------------------------------------------------------------------------------------------------------------
