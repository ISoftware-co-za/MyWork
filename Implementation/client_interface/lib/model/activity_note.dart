import 'model_property.dart';
import 'model_property_change_context.dart';
import 'validator_base.dart';

class ActivityNote extends PropertyOwner {
  //#region PROPERTIES

  String id;
  final DateTime timestamp;
  late final ModelProperty<String> text;
  bool get isNew => id == '';
  bool get isChanged => text.isChanged;

  //#endregion

  //#region CONSTRUCTION

  ActivityNote(ModelPropertyChangeContext super.context, this.id, this.timestamp, String text) {
    _initialiseInstance(text);
  }

  ActivityNote.create(ModelPropertyChangeContext super.context) :
    id = '',
    timestamp = DateTime.now() {
    _initialiseInstance('');
  }

  //#endregion

  //#region METHODS

  bool validate() => text.validate();

  //#endregion

  //#region PRIVATE METHODS

  void _initialiseInstance(String text) {
    this.text = ModelProperty(context: context, value: text,       validators: [
      ValidatorRequired(invalidMessageTemplate: 'What is required'),
      ValidatorMaximumCharacters(
        maximumCharacters: 300,
        invalidMessageTemplate: 'What should be 300 characters or less',
      ),
    ]);
  }

  //#endregion
}