library validator;

part 'validator_collection.dart';
part 'validator_required.dart';
part 'validator_maximum_characters.dart';

abstract class Validator<T> {
  String invalidMessageTemplate;

  Validator({required this.invalidMessageTemplate});

  String? validate(T input);
}