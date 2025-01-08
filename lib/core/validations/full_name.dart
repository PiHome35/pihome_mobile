import 'package:formz/formz.dart';

enum FullNameValidationError {
  empty('Full name cannot be empty'),
  invalid('Full name must be at least 2 characters'),
  tooLong('Full name must be less than 50 characters'),
  invalidFormat('Full name can only contain letters and spaces');

  final String message;
  const FullNameValidationError(this.message);
}

class FullName extends FormzInput<String, FullNameValidationError> {
  const FullName.pure() : super.pure('');
  const FullName.dirty([super.value = '']) : super.dirty();

  static final _fullNameRegex = RegExp(r'^[a-zA-Z\s]+$');

  @override
  FullNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return FullNameValidationError.empty;
    }
    if (value.length < 2) {
      return FullNameValidationError.invalid;
    }
    if (value.length > 50) {
      return FullNameValidationError.tooLong;
    }
    if (!_fullNameRegex.hasMatch(value)) {
      return FullNameValidationError.invalidFormat;
    }
    return null;
  }
}
