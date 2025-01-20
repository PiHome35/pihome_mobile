import 'package:equatable/equatable.dart';
import 'message.dart';

class ChatEntity extends Equatable {
  final String id;
  final String familyId;
  final String name;
  final MessageEntity? latestMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatEntity({
    required this.id,
    required this.familyId,
    required this.name,
    this.latestMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        familyId,
        name,
        latestMessage,
        createdAt,
        updatedAt,
      ];
}
