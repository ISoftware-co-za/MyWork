import 'package:client_interfaces1/state/property_changed_registry.dart';
import 'package:flutter/foundation.dart';

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

class StateProperty extends PropertyChangeNotifier {
  //#region PROPERTIES

  String? get value => _value;
  set value(String? value) {
    debugPrint('StateProperty.value: $value');
    if (_value != value) {
      _value = value;
      _updatePropertyChanged();
      _setInvalidMessage(_validation.validate(input: _value ?? ''));
      notifyPropertyChange("value");
    }
  }

  String? _value;

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

  //#endregion

  //#region CONSTRUCTION

  StateProperty({Object? value, List<Validator>? validators}) : _validation = ValidatorCollection(validators) {
    _value = _currentValue = value?.toString() ?? '';
  }

  //#endregion

  //#region METHODS

  bool validate() {
    _setInvalidMessage(_validation.validate(input: _value ?? '', forceErrors: true));
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
  String? _currentValue;
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

  String? validate({required String input, bool? forceErrors = false}) {
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

abstract class Validator {
  //#region PROPERTIES

  String invalidMessageTemplate;

  //#endregion

  //#region CONSTRUCTION

  Validator({required this.invalidMessageTemplate});

  //#endregion

  //#region METHODS

  String? validate(String input);

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class ValidatorRequired extends Validator {
  //#region CONSTRUCTION

  ValidatorRequired({required super.invalidMessageTemplate});

  //#endregion

  //#region METHODS

  @override
  String? validate(String input) {
    if (input.isEmpty) {
      return invalidMessageTemplate;
    }
    return null;
  }

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class ValidatorMaximumCharacters extends Validator {
  //#region PROPERTIES
  final int maximumCharacters;
  //#endregion

  //#region CONSTRUCTION

  ValidatorMaximumCharacters({required this.maximumCharacters,  required super.invalidMessageTemplate});

  //#endregion

  //#region METHODS

  @override
  String? validate(String input) {
    if (input.length > maximumCharacters) {
      return invalidMessageTemplate;
    }
    return null;
  }

//#endregion
}
