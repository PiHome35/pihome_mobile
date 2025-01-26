import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetAllChats extends ChatEvent {
  final String familyId;
  final int? limit;
  final int? offset;

  const GetAllChats({
    required this.familyId,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [familyId, limit, offset];
}

class GetChatMessages extends ChatEvent {
  final String chatId;
  final int? limit;
  final int? offset;

  const GetChatMessages({
    required this.chatId,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [chatId, limit, offset];
}

class CreateNewChat extends ChatEvent {
  final String familyId;

  const CreateNewChat({required this.familyId});

  @override
  List<Object?> get props => [familyId];
}

class CreatedNewChat extends ChatEvent {
  const CreatedNewChat();

  @override
  List<Object?> get props => [];
}

final class SendMessage extends ChatEvent {
  final String content;
  final String senderId;
  final String chatId;

  const SendMessage({
    required this.content,
    required this.senderId,
    required this.chatId,
  });

  @override
  List<Object?> get props => [content, senderId, chatId];
}

final class StartMessageSubscription extends ChatEvent {
  final String chatId;

  const StartMessageSubscription({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class StartChatSubscription extends ChatEvent {
  const StartChatSubscription();

  @override
  List<Object?> get props => [];
}

final class StopMessageSubscription extends ChatEvent {
  const StopMessageSubscription();

  @override
  List<Object?> get props => [];
}

class StopChatSubscription extends ChatEvent {
  const StopChatSubscription();

  @override
  List<Object?> get props => [];
}

final class NewMessageReceived extends ChatEvent {
  final MessageEntity message;

  const NewMessageReceived({required this.message});

  @override
  List<Object?> get props => [message];
}



final class LoadMoreMessages extends ChatEvent {
  final String chatId;
  final String lastMessageId;
  final int pageSize;

  const LoadMoreMessages({
    required this.chatId,
    required this.lastMessageId,
    this.pageSize = 20,
  });

  @override
  List<Object?> get props => [chatId, lastMessageId, pageSize];
}
