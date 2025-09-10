import 'package:client_interfaces1/model/validator_base.dart';
import './person.dart';

class ValidatorFirstLastName extends Validator<Person?> {
  ValidatorFirstLastName() : super(invalidMessageTemplate: '');

  @override
  String? validate(Person? person) {
    if (person == null) {
      return null;
    }
    if (person.firstName.value.isEmpty || person.lastName.value.isEmpty) {
      return 'A first and last name are required.';
    }
    bool fistNameValid = person.firstName.validate();
    bool lastNameValid = person.firstName.validate();
    String invalidMessage = '';
    if (fistNameValid == false) {
      invalidMessage += person.firstName.invalidMessage!;
    }
    if (lastNameValid == false) {
      if (invalidMessage.isNotEmpty) {
        invalidMessage += ' ';
      }
      invalidMessage += person.lastName.invalidMessage!;
    }
    if (invalidMessage.isEmpty) {
      return null;
    }
    return invalidMessage;
  }
}
