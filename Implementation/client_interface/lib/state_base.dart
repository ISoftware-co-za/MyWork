import 'package:flutter/cupertino.dart';

class StateBase extends ChangeNotifier {

  void invokeNotifyListeners() {
    notifyListeners();
  }
}

class StateActivityBase extends StateBase {
  final DateTime timestamp;

  StateActivityBase({required this.timestamp});
}

class StateProperty<T> {

  T? get value => _value;
  set value(T? value) {
    if (_value != value) {
      _value = value;
      _activityBase.invokeNotifyListeners();
    }
    _value = value;
  }
  T? _value;

  bool get isChanged => _currentValue != _value;

  bool get hasValue => _value != null;

  void saveCurrentValue() {
    _currentValue = _value;
  }

  StateProperty({required StateBase activityBase, T? value}) : _value = value, _currentValue = value, _activityBase = activityBase;

  final StateBase _activityBase;
  T? _currentValue;
}