import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError {
  empty('Please confirm your password'),
  mismatch('Passwords do not match');

  final String message;
  const ConfirmPasswordValidationError(this.message);
}

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  final String password;

  const ConfirmPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordValidationError.empty;
    }
    if (value != password) {
      return ConfirmPasswordValidationError.mismatch;
    }
    return null;
  }
}
