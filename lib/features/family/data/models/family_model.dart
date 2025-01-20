import 'package:mobile_pihome/features/family/domain/entities/family_entity.dart';

class FamilyModel extends FamilyEntity {
  const FamilyModel({
    required super.id,
    required super.name,
    required super.chatModelId,
    required super.ownerId,
    required super.inviteCode,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) {
    return FamilyModel(
      id: json['id'],
      name: json['name'],
      chatModelId: json['chatModelId'],
      ownerId: json['ownerId'],
      inviteCode: json['inviteCode'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chatModelId': chatModelId,
      'ownerId': ownerId,
      'inviteCode': inviteCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  FamilyEntity toEntity() {
    return FamilyEntity(
      id: id,
      name: name,
      chatModelId: chatModelId,
      ownerId: ownerId,
      inviteCode: inviteCode,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
