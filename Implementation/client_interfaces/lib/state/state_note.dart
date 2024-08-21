import 'state_base.dart';
import '../ui toolkit/properties.dart';

class StateNote extends StateActivityBase {

  late final StateProperty text;

  bool get isChanged => _currentText != text.value;

  StateNote({String? initialText, required super.timestamp}) {
    text = StateProperty(value: initialText);
  }

  void saveCurrentText() {
    _currentText = text.value;
  }

  String? _currentText;
}
