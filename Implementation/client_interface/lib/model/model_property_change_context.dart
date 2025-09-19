import 'package:flutter/foundation.dart';

import '../model/model_property.dart';

class ModelPropertyChangeContext {

  //#region PROPERTIES

  final String name;
  ValueNotifier<bool> hasChanges = ValueNotifier(false);
  int get changeCount => _changedProperties.length;

  //#endregion

  //#region CONSTRUCTION

  ModelPropertyChangeContext({required this.name});

  //#endregion

  //#region METHODS

  void addChangedProperty(ModelProperty property) {
    _changedProperties.add(property);
    hasChanges.value = _changedProperties.isNotEmpty;
  }

  void removeChangedProperty(ModelProperty property) {
    _changedProperties.remove(property);
    hasChanges.value = _changedProperties.isNotEmpty;
  }

  void acceptChanges() {
    for (var property in Set<ModelProperty>.from(_changedProperties)) {
      property.acceptChanged();
    }
  }

  void rejectChanges() {
    for (var property in Set<ModelProperty>.from(_changedProperties)) {
      property.discardChange();
    }
  }

  //#endregion

  //#region FIELDS

  final Set<ModelProperty> _changedProperties = {};

  //#endregion
}
