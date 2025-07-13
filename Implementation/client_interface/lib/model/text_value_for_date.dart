import 'package:client_interfaces1/model/properties.dart';
import 'package:intl/intl.dart';

abstract class TextValueBase<T> {
  String get value;
  set value(String value);
  void onValueSet(T value);
  bool validateValue();
}

//------------------------------------------------------------------------------

class TextValueForDate extends PropertyChangeNotifier
    implements TextValueBase<DateTime> {
  @override
  String get value => _value;
  @override
  set value(String value) {
    if (_setValueHelper(value)) {
      _transmitValueToDateProperty(value);
    }
  }

  String _value = '';

  TextValueForDate(this._dateProperty) {
    _value = _dateProperty.value != null
        ? DateFormat.yMd().format(_dateProperty.value)
        : '';
  }

  void onValueSet(DateTime value) {
    _setValueHelper(DateFormat.yMd().format(value));
  }

  bool validateValue() {
    _hasBeenValid = true;
    _transmitValueToDateProperty(value);
    return _dateProperty.isValid;
  }

  bool _setValueHelper(String value) {
    if (_value != value) {
      _value = value;
      notifyPropertyChange("value");
      return true;
    }
    return false;
  }

  void _transmitValueToDateProperty(String value) {
    try {
      if (value.isEmpty) {
        _dateProperty.value = null;
      } else {
        _dateProperty.value = DateFormat.yMd().parse(value);
      }
      _hasBeenValid = true;
    } catch (e) {
      if (_hasBeenValid) {
        _dateProperty.setInvalidMessage('Invalid date format');
      }
    }
  }

  final StateProperty _dateProperty;
  bool _hasBeenValid = false;
}
