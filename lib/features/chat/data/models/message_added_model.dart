import '../../domain/entities/message_added.dart';

class MessageAddedModel extends MessageAdded {
  const MessageAddedModel({
    required super.id,
    required super.content,
    required super.senderUserId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MessageAddedModel.fromJson(Map<String, dynamic> json) {
    return MessageAddedModel(
      id: json['id'] as String,
      content: json['content'] as String,
      senderUserId: json['senderUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderUserId': senderUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MessageAdded toEntity() => this;
}
