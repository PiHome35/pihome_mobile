import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/core/data/models/user_model.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.familyId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? familyId;
  final String createdAt;
  final String updatedAt;

  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      familyId: familyId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];
}
