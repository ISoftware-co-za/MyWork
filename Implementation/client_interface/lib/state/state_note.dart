
import 'state_base.dart';

class StateNote extends StateActivityBase {

  late final StateProperty<String?> text;

  bool get isChanged => _currentText != text.value;

  StateNote({String? initialText, required super.timestamp}) {
    text = StateProperty<String?>(activityBase: this, value: initialText);
  }

  void saveCurrentText() {
    _currentText = text.value;
  }

  String? _currentText;
}
