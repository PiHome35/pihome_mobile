import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mobile_pihome/core/validations/confirm_password.dart';
import 'package:mobile_pihome/core/validations/email.dart';
import 'package:mobile_pihome/core/validations/name.dart';
import 'package:mobile_pihome/core/validations/password.dart';

final class AuthState extends Equatable {
  const AuthState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.name = const Name.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final Name name;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  AuthState copyWith({
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    Name? name,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      name: name ?? this.name,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        name,
        status,
        isValid,
        errorMessage,
      ];
}
