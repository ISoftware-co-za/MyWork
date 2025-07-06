import 'package:flutter/foundation.dart';

import '../model/properties.dart';

class PropertyChangedRegistry {

  static ValueNotifier<bool> hasChanges = ValueNotifier(false);
  static int get changeCount => _changedProperties.length;

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

  static final Set<StateProperty> _changedProperties = {};
}
