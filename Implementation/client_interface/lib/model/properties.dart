import 'package:client_interfaces1/model/text_value_for_date.dart';
import 'package:flutter/foundation.dart';

import '../service/update_entity.dart';
import 'property_changed_registry.dart';
import 'validator_base.dart';

//----------------------------------------------------------------------------------------------------------------------

class PropertyOwner extends ChangeNotifier {
  late final Map<String, StateProperty> properties;

  List<UpdateEntityProperty> listUpdatedProperties() {
    var updatedProperties = <UpdateEntityProperty>[];
    for (var propertyEntry in properties.entries) {
      if (propertyEntry.value.isChanged) {
        updatedProperties.add(
          UpdateEntityProperty(
            name: propertyEntry.key,
            value: propertyEntry.value.value,
          ),
        );
      }
    }
    return updatedProperties;
  }

  void invalidate(Map<String, List<String>> errors) {
    for (var entry in errors.entries) {
      assert(properties[entry.key] != null);
      properties[entry.key]?.invalidate(entry.value.first);
    }
  }
}

//----------------------------------------------------------------------------------------------------------------------

class PropertyChangeNotifier extends ChangeNotifier {
  String? notifyingProperty;

  void notifyPropertyChange(String propertyName) {
    notifyingProperty = propertyName;
    notifyListeners();
  }
}

//----------------------------------------------------------------------------------------------------------------------

class StateProperty<T> extends PropertyChangeNotifier {
  T get value => _value;
  set value(T value) {
    if (onValueSet(value) && _textValueBase != null) {
      _textValueBase.onValueSet(value);
    }
  }

  T _value;

  String? get invalidMessage => _invalidMessage;
  void setInvalidMessage(String? value) {
    if (_invalidMessage != value) {
      _invalidMessage = value;
      notifyPropertyChange("invalidMessage");
    }
  }

  String? _invalidMessage;

  bool get isChanged => _propertyChanged.isChanged;

  bool get hasValue => _value != null;

  bool get isValid => _invalidMessage == null;

  String get valueAsString => (_value != null) ? _value.toString() : '';

  StateProperty({
    required T value,
    List<Validator>? validators,
    TextValueBase<T>? textValueBase,
  }) : _value = value,
       _currentValue = value,
       _validation = ValidatorCollection(validators),
       _textValueBase = textValueBase;

  void setValue(T newValue) {
    _currentValue = _value = newValue;
    _updatePropertyChanged();
  }

  bool onValueSet(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      setInvalidMessage(_validation.validate(input: _value.toString()));
      _updatePropertyChanged();
      notifyPropertyChange("value");
      return true;
    }
    return false;
  }

  bool validate() {
    if (_textValueBase == null || _textValueBase.validateValue()) {
      setInvalidMessage(_validation.validate(input: _value, forceErrors: true));
    }
    return isValid;
  }

  void invalidate(String message) {
    setInvalidMessage(message);
  }

  void acceptChanged() {
    _currentValue = value;
    _updatePropertyChanged();
  }

  void discardChange() {
    _validation.reset();
    value = _currentValue;
    _updatePropertyChanged();
  }

  void _updatePropertyChanged() {
    if (_propertyChanged.setChanged(this, _currentValue != _value)) {
      notifyPropertyChange("isChanged");
    }
  }

  final ValidatorCollection _validation;
  T _currentValue;
  final _PropertyChanged _propertyChanged = _PropertyChanged();
  final TextValueBase<T>? _textValueBase;
}

//----------------------------------------------------------------------------------------------------------------------

class _PropertyChanged {
  bool isChanged = false;
  bool result = false;

  bool setChanged(StateProperty property, bool changed) {
    isChanged = changed;
    if (isChanged && _changedPropertyRegistered == false) {
      PropertyChangedRegistry.addChangedProperty(property);
      _changedPropertyRegistered = true;
      result = true;
    } else if (isChanged == false && _changedPropertyRegistered) {
      PropertyChangedRegistry.removeChangedProperty(property);
      _changedPropertyRegistered = false;
      result = true;
    }
    return result;
  }

  bool _changedPropertyRegistered = false;
}

//----------------------------------------------------------------------------------------------------------------------
