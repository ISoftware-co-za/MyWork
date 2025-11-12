import 'package:client_interfaces1/service/service_client_base.dart';

import '../model/data_conversion.dart';

class ChangeEntityRequest {
  final Iterable<EntityProperty>? updatedProperties;
  final Iterable<ChangeChildEntity>? childUpdates;

  ChangeEntityRequest({
    this.updatedProperties = null,
    this.childUpdates = null,
  });

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();
    if (updatedProperties != null) {
      map['updatedProperties'] = updatedProperties;
    }
    if (childUpdates != null) {
      map['childUpdates'] = childUpdates;
    }
    return map;
  }
}

class EntityProperty {
  final String name;
  final dynamic value;
  EntityProperty({required this.name, this.value});

  Map<String, dynamic> toJson() {
    dynamic jsonValue = value;
    if (value != null &&
        value is Enum /* value.runtimeType.toString() == 'ActivityState'*/ ) {
      jsonValue = (value as Enum).name;
    } else if (jsonValue is DateTime) {
      jsonValue = DataConversionModelToService.toISO8601Date(jsonValue);
    } else if (jsonValue is EntityPropertyProvider) {
      jsonValue = jsonValue.providedProperty;
    }
    return {'name': name, 'value': jsonValue};
  }
}

abstract class EntityPropertyProvider {
  dynamic get providedProperty;
}

class ChangeChildEntity {
  final String createTypeName;
  final List<CreateChild>? create;
  final List<UpdateChild>? update;
  final List<DeleteChild>? delete;

  ChangeChildEntity({
    required this.createTypeName,
    this.create,
    this.update,
    this.delete,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'createTypeName': createTypeName};
    if (create != null) {
      map['create'] = create!.map((c) => c.toJson()).toList();
    }
    if (update != null) {
      map['update'] = update!.map((u) => u.toJson()).toList();
    }
    if (delete != null) {
      map['delete'] = delete!.map((d) => d.toJson()).toList();
    }
    return map;
  }
}

class CreateChild {
  final Iterable<EntityProperty> properties;

  CreateChild(this.properties);

  Map<String, dynamic> toJson() {
    return {'properties': properties.map((p) => p.toJson()).toList()};
  }
}

class UpdateChild {
  final String id;
  final Iterable<EntityProperty> updatedProperties;

  UpdateChild(this.id, this.updatedProperties);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'updatedProperties': updatedProperties.map((p) => p.toJson()).toList(),
    };
  }
}

class DeleteChild {
  final String id;

  DeleteChild(this.id);

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class ChangeEntityResponse extends ServiceClientResponse {
  final ResultBase? result;
  final List<ChildEntityTypeInResponse>? childUpdateResults;

  ChangeEntityResponse({
    this.result,
    this.childUpdateResults,
  });

  ChildEntityTypeInResponse? getUpdateForEntityType(String createTypeName) {
    if (childUpdateResults == null) return null;
    for (final entity in childUpdateResults!) {
      if (entity.createTypeName == createTypeName) return entity;
    }
    return null;
  }

  factory ChangeEntityResponse.fromJson(Map<String, dynamic> json) {
    return ChangeEntityResponse(
      result: json['result'] != null
          ? ResultBase.fromJson(json['result'] as Map<String, dynamic>)
          : null,
      childUpdateResults: (json['childUpdateResults'] as List<dynamic>?)
          ?.map((e) => ChildEntityTypeInResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ResultBase {
  final bool? success;
  final String? failureMessage;

  ResultBase({required this.success, required this.failureMessage});

  factory ResultBase.fromJson(Map<String, dynamic> json) {
    return ResultBase(
      success: json['success'] as bool?,
      failureMessage: json['failureMessage'] as String?,
    );
  }
}

class ChildEntityTypeInResponse {
  final String createTypeName;
  final List<CreateChildResult>? createResults;
  final List<ResultBase>? updateResults;
  final List<ResultBase>? deleteResults;

  ChildEntityTypeInResponse({
    required this.createTypeName,
    required this.createResults,
    required this.updateResults,
    required this.deleteResults,
  });

  factory ChildEntityTypeInResponse.fromJson(Map<String, dynamic> json) {
    return ChildEntityTypeInResponse(
      createTypeName: json['createTypeName'].toString(),
      createResults: (json['createResults'] as List<dynamic>?)
          ?.map((e) => CreateChildResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      updateResults: (json['updateResults'] as List<dynamic>?)
          ?.map((e) => ResultBase.fromJson(e as Map<String, dynamic>))
          .toList(),
      deleteResults: (json['deleteResults'] as List<dynamic>?)
          ?.map((e) => ResultBase.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<String>? listCreateIds() {
    if (createResults != null) {
      List<String> ids = [];
      for(CreateChildResult createChildResult in createResults!) {
        if (createChildResult.success == true) {
          ids.add(createChildResult.id!);
        }
      }
    }
    return null;
  }
}

class CreateChildResult extends ResultBase{
  final String? id;

  CreateChildResult({super.success, super.failureMessage, this.id});

  factory CreateChildResult.fromJson(Map<String, dynamic> json) {
    return CreateChildResult(
      success: json['success'] as bool?,
      failureMessage: json['failureMessage'] as String?,
      id: json['id'] as String?,
    );
  }
}