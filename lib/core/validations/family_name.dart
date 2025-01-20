import 'package:formz/formz.dart';

enum FamilyNameValidationError {
  empty('Family name cannot be empty'),
  tooShort('Family name must be at least 3 characters'),
  tooLong('Family name must be less than 50 characters'),
  invalidFormat('Family name can only contain letters, numbers and spaces');

  final String message;
  const FamilyNameValidationError(this.message);
}

class FamilyName extends FormzInput<String, FamilyNameValidationError> {
  const FamilyName.pure() : super.pure('');
  const FamilyName.dirty([super.value = '']) : super.dirty();

  static final _familyNameRegex = RegExp(r'^[a-zA-Z0-9\s]+$');

  @override
  FamilyNameValidationError? validator(String value) {
    if (value.isEmpty) {
      return FamilyNameValidationError.empty;
    }
    if (value.length < 3) {
      return FamilyNameValidationError.tooShort;
    }
    if (value.length > 50) {
      return FamilyNameValidationError.tooLong;
    }
    if (!_familyNameRegex.hasMatch(value)) {
      return FamilyNameValidationError.invalidFormat;
    }
    return null;
  }
}
