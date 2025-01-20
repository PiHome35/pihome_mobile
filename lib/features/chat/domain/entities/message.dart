import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String content;
  final String chatId;
  final String senderId;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.chatId,
    required this.senderId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, chatId, senderId, createdAt];
}
