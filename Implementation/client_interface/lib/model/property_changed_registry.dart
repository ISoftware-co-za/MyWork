import 'package:flutter/foundation.dart';

import '../model/properties.dart';

class PropertyChangedRegistry {

  //#region PROPERTIES

  static ValueNotifier<bool> hasChanges = ValueNotifier(false);

  //#endregion

  //#region METHODS

  static void addChangedProperty(StateProperty property) {
    _changedProperties.add(property);
    hasChanges.value = _changedProperties.isNotEmpty;
  }

  static void removeChangedProperty(StateProperty property) {
    _changedProperties.remove(property);
    hasChanges.value = _changedProperties.isNotEmpty;
  }

  static void acceptChanges() {
    for (var property in Set<StateProperty>.from(_changedProperties)) {
      property.acceptChanged();
    }
  }

  static void rejectChanges() {
    for (var property in Set<StateProperty>.from(_changedProperties)) {
      property.discardChange();
    }
  }

  /*
  static bool validateChanges() {
    bool changesValid = true;
    for (var property in _changedProperties) {
      changesValid = changesValid && property.validate();
    }
    return changesValid;
  }
  */

  //#endregion

  //#region FIELDS

  static final Set<StateProperty> _changedProperties = {};

  //#endregion
}
