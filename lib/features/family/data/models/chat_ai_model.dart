import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';

class ChatAiModel extends ChatAiModelEntity {
  const ChatAiModel({
    required super.id,
    required super.name,
    required super.key,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChatAiModel.fromJson(Map<String, dynamic> json) {
    return ChatAiModel(
      id: json['id'],
      name: json['name'],
      key: json['key'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'key': key,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ChatAiModelEntity toEntity() {
    return ChatAiModelEntity(
      id: id,
      name: name,
      key: key,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
