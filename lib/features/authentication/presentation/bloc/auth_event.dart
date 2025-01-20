sealed class AuthEvent {
  const AuthEvent();
}

final class EmailChanged extends AuthEvent {
  const EmailChanged(this.email);
  final String email;
}

final class PasswordChanged extends AuthEvent {
  const PasswordChanged(this.password);
  final String password;
}

final class ConfirmPasswordChanged extends AuthEvent {
  const ConfirmPasswordChanged(this.confirmPassword);
  final String confirmPassword;
}

final class NameChanged extends AuthEvent {
  const NameChanged(this.name);
  final String name;
}

final class LoginSubmitted extends AuthEvent {
  const LoginSubmitted();
}

final class CheckAuth extends AuthEvent {
  const CheckAuth();
}

final class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  List<Object?> get props => [email, password, name,];
}
