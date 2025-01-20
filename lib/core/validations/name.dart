import 'package:formz/formz.dart';

enum NameValidationError {
  empty('Full name cannot be empty'),
  invalid('Full name must be at least 2 characters'),
  tooLong('Full name must be less than 50 characters'),
  invalidFormat('Full name can only contain letters and spaces');

  final String message;
  const NameValidationError(this.message);
}

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    }
    if (value.length < 2) {
      return NameValidationError.invalid;
    }
    if (value.length > 50) {
      return NameValidationError.tooLong;
    }
    if (!_nameRegex.hasMatch(value)) {
      return NameValidationError.invalidFormat;
    }
    return null;
  }
}
