import 'package:equatable/equatable.dart';

class FamilyEntity extends Equatable {
  final String id;
  final String name;
  final String? chatModelId;
  final String ownerId;
  final String? inviteCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FamilyEntity({
    required this.id,
    required this.name,
    this.chatModelId,
    required this.ownerId,
    this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        chatModelId,
        ownerId,
        inviteCode,
        createdAt,
        updatedAt,
      ];
}
