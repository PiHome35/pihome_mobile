import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String password;
  final String username;

  const RegisterEntity({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password, username];
}
