import '../model/activity.dart';
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
    if (value != null && value.runtimeType.toString() == 'ActivityState') {
      var activityState = value as ActivityState;
      jsonValue = activityState.name;
    } else if (jsonValue is DateTime) {
      jsonValue = DataConversionModelToService.dateTimeToDateString(jsonValue);
    }
    return {
      'name': name,
      'value': jsonValue,
    };
  }
}
