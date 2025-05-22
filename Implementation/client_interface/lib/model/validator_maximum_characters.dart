part of validator;

class ValidatorMaximumCharacters<T> extends Validator<T> {
  final int maximumCharacters;

  ValidatorMaximumCharacters(
      {required this.maximumCharacters, required super.invalidMessageTemplate});

  @override
  String? validate(T input) {
    if (input.toString().length > maximumCharacters) {
      return invalidMessageTemplate;
    }
    return null;
  }
}