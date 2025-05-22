part of validator;

class ValidatorRequired<T> extends Validator<T> {
  ValidatorRequired({required super.invalidMessageTemplate});

  @override
  String? validate(T input) {
    if (input == null || input.toString().isEmpty) {
      return invalidMessageTemplate;
    }
    return null;
  }
}