import 'package:equatable/equatable.dart';

class NewChatEntity extends Equatable {
  final String id;
  final String name;
  const NewChatEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
