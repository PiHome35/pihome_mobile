import 'package:mobile_pihome/features/chat/domain/entities/chat_model.dart';

class ChatModelModel extends ChatModelEntity {
  const ChatModelModel({
    required super.id,
    required super.key,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChatModelModel.fromJson(Map<String, dynamic> json) {
    return ChatModelModel(
      id: json['id'],
      key: json['key'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
