import 'package:client_interfaces1/model/model_property_change_context.dart';
import 'package:get_it/get_it.dart';

import '../service/service_client_base.dart';
import '../service/update_entity.dart';
import '../service/work/service_client_work.dart';
import '../service/work/load_work_details.dart';
import 'data_conversion.dart';
import 'model_property.dart';
import 'validator_base.dart';

class Work extends PropertyOwner {
  late String id;
  late final ModelProperty<String> name;
  late final ModelProperty<String> reference;
  late final ModelProperty<String> description;
  late final ModelProperty<String> type;
  late final ModelProperty<bool> archived;

  bool get isNew => id.isEmpty;

  Work.create(ModelPropertyChangeContext super.context) {
    id = '';
    _initialiseInstance('', null, false, null);
  }

  Work({
    required ModelPropertyChangeContext context,
    required this.id,

    required String name,
    required String? reference,
    required String? type,
    required bool archived,
  }) : super(context) {
    _initialiseInstance(name, reference, archived, type);
  }

  bool validate() {
    return name.validate() &&
        reference.validate() &&
        description.validate() &&
        type.validate();
  }

  Future save() async {
    var request = CreateWorkRequest(
      name: name.value,
      type: type.value,
      reference: reference.value,
      description: description.value,
    );
    var response = await GetIt.instance<ServiceClientWork>().create(request);
    if (response is CreateWorkResponse) {
      id = response.id;
    } else if (response is ValidationProblemResponse) {
      invalidate(response.errors);
    }
  }

  Future update() async {
    List<EntityProperty> updatedProperties = listUpdatedProperties();
    if (updatedProperties.isNotEmpty) {
      var request = ChangeEntityRequest(
        updatedProperties: updatedProperties,
      );
      var response = await _serviceClient.update(id, request);
      if (response is ValidationProblemResponse) {
        invalidate(response.errors);
      }
    }
  }

  Future loadDetails() async {
    if (!_isLoaded) {
      LoadWorkDetailsResponse response = await _serviceClient.loadDetails(id);
      description.setValueWithNotification(
        DataConversionServiceToModel.nullToEmptyString(
          response.details.description,
        ),
        ignorePropertyChanged: true,
        ignoreNotification: true,
      );
      _isLoaded = true;
    }
  }

  Future delete() async {
    await _serviceClient.delete(id);
  }

  void _initialiseInstance(
    String name, [
    String? reference,
    bool? archived = false,
    String? type,
  ]) {
    if (reference == null) {
      reference = '';
    }
    if (type == null) {
      type = '';
    }
    this.name = ModelProperty(
      context: context,
      value: name,
      validators: [
        ValidatorRequired(invalidMessageTemplate: 'Name is required'),
        ValidatorMaximumCharacters(
          maximumCharacters: 80,
          invalidMessageTemplate: 'Name should be 80 characters or less',
        ),
      ],
    );
    this.reference = ModelProperty(
      context: context,
      value: reference,
      validators: [
        ValidatorMaximumCharacters(
          maximumCharacters: 40,
          invalidMessageTemplate: 'Reference should be 40 characters or less',
        ),
      ],
    );
    this.description = ModelProperty(context: context, value: '');
    this.archived = ModelProperty(context: context, value: archived!);
    this.type = ModelProperty<String>(
      context: context,
      value: type,
      validators: [
        ValidatorMaximumCharacters(
          maximumCharacters: 40,
          invalidMessageTemplate: 'Type should be 40 characters or less',
        ),
      ],
    );
    properties = {
      'name': this.name,
      'reference': this.reference,
      'description': this.description,
      'type': this.type,
    };
  }

  final ServiceClientWork _serviceClient = GetIt.instance<ServiceClientWork>();
  bool _isLoaded = false;
}
