import 'package:equatable/equatable.dart';

class ChatAiModelEntity extends Equatable {
  final String id;
  final String name;
  final String key;
  final String createdAt;
  final String updatedAt;

  const ChatAiModelEntity({
    required this.id,
    required this.name,
    required this.key,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        key,
        createdAt,
        updatedAt,
      ];
}
