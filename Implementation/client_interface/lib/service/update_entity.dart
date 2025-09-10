import '../model/data_conversion.dart';

class UpdateEntityRequest {
  final String id;
  final Iterable<UpdateEntityProperty> updatedProperties;

  UpdateEntityRequest({required this.id, required this.updatedProperties});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updatedProperties': updatedProperties,
    };
  }
}

class UpdateEntityProperty {
  final String name;
  final dynamic value;
  UpdateEntityProperty({required this.name, this.value});

  Map<String, dynamic> toJson() {
    dynamic jsonValue = value;
    if (value != null && value is Enum /* value.runtimeType.toString() == 'ActivityState'*/) {
      jsonValue = (value as Enum).name;
    } else if (jsonValue is DateTime) {
      jsonValue = DataConversionModelToService.dateTimeToDateString(jsonValue);
    } else if (jsonValue is UpdateEntityPropertyProvider) {
      jsonValue = jsonValue.providedProperty;
    }
    return {
      'name': name,
      'value': jsonValue,
    };
  }
}

abstract class UpdateEntityPropertyProvider {
  dynamic get providedProperty;
}
