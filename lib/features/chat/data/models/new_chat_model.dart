import 'package:mobile_pihome/features/chat/domain/entities/new_chat.dart';

class NewChatModel {
  final String id;
  final String name;

  NewChatModel({required this.id, required this.name});

  factory NewChatModel.fromJson(Map<String, dynamic> json) {
    return NewChatModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  NewChatEntity toEntity() {
    return NewChatEntity(
      id: id,
      name: name,
    );
  }
}
