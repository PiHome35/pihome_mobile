import 'package:equatable/equatable.dart';

class ChatModelEntity extends Equatable {
  final String id;
  final String key;
  final String name;
  final String createdAt;
  final String updatedAt;

  const ChatModelEntity({
    required this.id,
    required this.key,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        key,
        name,
        createdAt,
        updatedAt,
      ];
}
