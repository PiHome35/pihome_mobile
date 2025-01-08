import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty('Password cannot be empty'),
  tooShort('Password must be at least 8 characters'),
  noUpperCase('Password must contain at least one uppercase letter'),
  noLowerCase('Password must contain at least one lowercase letter'),
  noNumber('Password must contain at least one number');

  final String message;
  const PasswordValidationError(this.message);
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationError.noUpperCase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationError.noLowerCase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return PasswordValidationError.noNumber;
    }
    return null;
  }
}
