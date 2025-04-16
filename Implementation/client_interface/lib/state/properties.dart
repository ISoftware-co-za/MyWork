import 'package:client_interfaces1/state/property_changed_registry.dart';
import 'package:flutter/foundation.dart';

//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------

class StateProperty<T> extends ChangeNotifier {
  //#region PROPERTIES

  T? get value => _value;
  set value(T? value) {
    if (_value != value) {
      _value = value;
      _updatePropertyChanged();
      _setInvalidMessage(_validation.validate(input: _value.toString()));
    }
  }

  T? _value;

  String? get invalidMessage => _invalidMessage;
  void _setInvalidMessage(String? value) {
     if (_invalidMessage != value) {
      _invalidMessage = value;
      isValid = _invalidMessage == null || _invalidMessage!.isEmpty;
    }
  }

  String? _invalidMessage;

  bool get isValid => _isValid;
  set isValid(bool value) {
    if (_isValid != value) {
      _isValid = value;
      notifyListeners();
    }
  }

  bool _isValid = true;

  bool get isChanged => _isChanged;
  set isChanged(bool value) {
    if (_isChanged != value) {
      _isChanged = value;
      notifyListeners();
    }
  }

  bool _isChanged = false;

  bool get hasValue => _value != null;
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
    isValid = (_invalidMessage == null);
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
      isChanged = true;
    } else {
      isChanged = false;
    }
  }

  //#endregion

  //#region FIELDS

  final ValidatorCollection _validation;
  T? _currentValue;
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

class ValidatorCollection {
  //#region CONSTRUCTION

  ValidatorCollection(List<Validator>? validators) {
    if (validators != null) {
      _validators.addAll(validators);
    }
  }

  //#endregion

  //#region METHODS

  void add(Validator validator) {
    _validators.add(validator);
  }

  String? validate({required dynamic input, bool? forceErrors = false}) {
    for (var validator in _validators) {
      final result = validator.validate(input);
      if ((_hasBeenValid || forceErrors!) && result != null) {
        return result;
      }
    }
    _hasBeenValid = true;
    return null;
  }

  void reset() {
    _hasBeenValid = false;
  }

  //#endregion

  //#region FIELDS

  final _validators = <Validator>[];
  bool _hasBeenValid = false;

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

abstract class Validator<T> {
  //#region PROPERTIES

  String invalidMessageTemplate;

  //#endregion

  //#region CONSTRUCTION

  Validator({required this.invalidMessageTemplate});

  //#endregion

  //#region METHODS

  String? validate(T input);

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class ValidatorRequired<T> extends Validator<T> {
  //#region CONSTRUCTION

  ValidatorRequired({required super.invalidMessageTemplate});

  //#endregion

  //#region METHODS

  @override
  String? validate(T input) {
    if (input == null || input.toString().isEmpty) {
      return invalidMessageTemplate;
    }
    return null;
  }

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class ValidatorMaximumCharacters<T> extends Validator<T> {
  //#region PROPERTIES
  final int maximumCharacters;
  //#endregion

  //#region CONSTRUCTION

  ValidatorMaximumCharacters(
      {required this.maximumCharacters, required super.invalidMessageTemplate});

  //#endregion

  //#region METHODS

  @override
  String? validate(T input) {
    if (input.toString().length > maximumCharacters) {
      return invalidMessageTemplate;
    }
    return null;
  }

//#endregion
}
