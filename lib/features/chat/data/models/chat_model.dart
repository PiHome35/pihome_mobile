import '../../domain/entities/chat.dart';
import 'message_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.familyId,
    required super.name,
    super.latestMessage,
    required super.createdAt,
    required super.updatedAt,
    super.deviceId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final latestMessage = json['latestMessage'] != null
        ? MessageModel.fromJson(json['latestMessage'] as Map<String, dynamic>)
        : null;
    return ChatModel(
      id: json['id'] as String,
      familyId: json['familyId'] as String,
      name: json['name'] as String,
      latestMessage: latestMessage?.toEntity(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deviceId: json['deviceId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'familyId': familyId,
      'name': name,
      'latestMessage': latestMessage != null
          ? (latestMessage as MessageModel).toJson()
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deviceId': deviceId,
    };
  }

  ChatEntity toEntity() => this;
}
