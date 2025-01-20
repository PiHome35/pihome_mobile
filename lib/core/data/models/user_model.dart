import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_pihome/core/constants/hive_constant.dart';
import 'package:mobile_pihome/core/domain/entities/user.dart';
part 'user_model.g.dart';

@HiveType(typeId: HiveConstant.userTypeId)
class UserModel {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;
  
  @HiveField(2)
  late String email;

  @HiveField(3)
  late String? familyId;
  
  @HiveField(4)
  late String createdAt;

  @HiveField(5)
  late String updatedAt;


  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.familyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      familyId: json['familyId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'familyId': familyId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      familyId: entity.familyId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      familyId: familyId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
