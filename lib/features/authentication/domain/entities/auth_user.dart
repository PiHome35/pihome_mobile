import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String familyId;

  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.familyId,
  });

  @override
  List<Object?> get props => [id, email, fullName, familyId];
}
