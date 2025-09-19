import 'package:client_interfaces1/model/model_property_change_context.dart';

import 'model_property.dart';
import 'state_activity_base.dart';

class StateNote extends StateActivityBase {

  late final ModelProperty text;

  bool get isChanged => _currentText != text.value;

  StateNote({required ModelPropertyChangeContext context, String? initialText, required super.timestamp}) : super(context: context) {
    text = ModelProperty(context: context, value: initialText);
  }

  void saveCurrentText() {
    _currentText = text.value;
  }

  String? _currentText;
}
