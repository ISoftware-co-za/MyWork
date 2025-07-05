import 'package:client_interfaces1/model/activity_list.dart';
import 'package:get_it/get_it.dart';

import '../service/service_client_base.dart';
import '../service/update_entity.dart';
import '../service/work/service_client_work.dart';
import '../service/work/load_work_details.dart';
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
  late final ActivityList activities;

  bool get isNew => id.isEmpty;

  Work.create() {
    id = '';
    _defineValidation('');
  }

  Work({required this.id,
    required String name,
    required String? reference,
    required String? type,
    required bool archived}) {
    _defineValidation(name, reference, archived, type);
  }

  bool validate() {
    return name.validate() &&
        reference.validate() &&
        description.validate() &&
        type.validate();
  }

  Future save() async {
    var request = RequestCreateWork(
        name: name.value,
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
    List<UpdateEntityProperty> updatedProperties =listUpdatedProperties();
    if (updatedProperties.isNotEmpty) {
      var request =
      UpdateEntityRequest(id: id, updatedProperties: updatedProperties);
      var response = await _serviceClient.update(request);
      if (response is ValidationProblemResponse) {
        invalidate(response.errors);
      }
    }
  }

  Future delete() async {
    await _serviceClient.delete(id);
  }

  void _defineValidation(String name, [String? reference, bool? archived = false, String? type]) {
    if (reference == null) {
      reference = '';
    }
    if (type == null) {
      type = '';
    }
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
    this.description = StateProperty(value: '');
    this.archived = StateProperty(value: archived!);
    this.type = StateProperty<String>(
        value: type,
        validators: [
          ValidatorMaximumCharacters(
              maximumCharacters: 40,
              invalidMessageTemplate: 'Type should be 40 characters or less')
        ]);
    this.activities = ActivityList(id);
    properties = {
      'Name': this.name,
      'Reference': this.reference,
      'Description': this.description,
      'Type': this.type
    };
  }

  final ServiceClientWork _serviceClient = GetIt.instance<ServiceClientWork>();
  bool _isLoaded = false;
}
