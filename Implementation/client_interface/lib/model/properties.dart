import 'package:flutter/foundation.dart';

import 'property_changed_registry.dart';
import 'validator_base.dart';

//----------------------------------------------------------------------------------------------------------------------

class PropertyOwner extends ChangeNotifier {}

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
  //#region PROPERTIES

  T? get value => _value;
  set value(T? value) {
    if (_value != value) {
      _value = value;
      _setInvalidMessage(_validation.validate(input: _value.toString() ?? ''));
      _updatePropertyChanged();
      notifyPropertyChange("value");
    }
  }

  T? _value;

  String? get invalidMessage => _invalidMessage;
  void _setInvalidMessage(String? value) {
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

  //#endregion

  //#region CONSTRUCTION

  StateProperty({T? value, List<Validator>? validators})
      : _validation = ValidatorCollection(validators) {
    _value = value;
  }

  //#endregion

  //#region METHODS

  void setValue(Object object) {
    value = object as T;
  }

  bool validate() {
    _setInvalidMessage(_validation.validate(input: _value, forceErrors: true));
    return isValid;
  }

  void invalidate({required String message}) {
    _setInvalidMessage(message);
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

  //#endregion

  //#region PRIVATE METHODS

  void _updatePropertyChanged() {
    if (_propertyChanged.setChanged(this, _currentValue != _value)) {
      notifyPropertyChange("isChanged");
    }
  }

  //#endregion

  //#region FIELDS

  final ValidatorCollection _validation;
  T? _currentValue;
  ValueNotifier<bool> _isChanged = ValueNotifier<bool>(false);
  final _PropertyChanged _propertyChanged = _PropertyChanged();

  //#endregion
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