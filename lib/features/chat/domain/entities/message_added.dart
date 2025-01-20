import 'package:equatable/equatable.dart';

class MessageAdded extends Equatable {
  final String id;
  final String content;
  final String senderUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MessageAdded({
    required this.id,
    required this.content,
    required this.senderUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        content,
        senderUserId,
        createdAt,
        updatedAt,
      ];
}
