import '../../domain/entities/message.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.content,
    required super.chatId,
    required super.senderId,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'chatId': chatId,
      'senderId': senderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MessageEntity toEntity() => this;
}
