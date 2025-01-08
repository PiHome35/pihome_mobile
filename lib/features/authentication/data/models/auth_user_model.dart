import 'package:mobile_pihome/features/authentication/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.familyId,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      familyId: json['familyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'familyId': familyId,
    };
  }

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      email: email,
      fullName: fullName,
      familyId: familyId,
    );
  }
}
