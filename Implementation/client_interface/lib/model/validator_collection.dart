part of validator;

class ValidatorCollection {
  ValidatorCollection(List<Validator>? validators) {
    if (validators != null) {
      _validators.addAll(validators);
    }
  }

  void add(Validator validator) {
    _validators.add(validator);
  }

  String? validate({required dynamic input, bool? forceErrors = false}) {
    for (var validator in _validators) {
      final result = validator.validate(input);
      if ((_hasBeenValid || forceErrors!) && result != null) {
        return result;
      }
    }
    _hasBeenValid = true;
    return null;
  }

  void reset() {
    _hasBeenValid = false;
  }

  final _validators = <Validator>[];
  bool _hasBeenValid = false;
}