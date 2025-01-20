import 'package:mobile_pihome/features/chat/domain/entities/message.dart';

sealed class ChatEvent {
  const ChatEvent();
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
}

class CreateNewChat extends ChatEvent {
  final String familyId;

  const CreateNewChat({required this.familyId});
}

class CreatedNewChat extends ChatEvent {
  const CreatedNewChat();
}

class SendMessage extends ChatEvent {
  final String content;
  final String senderId;
  final String chatId;

  const SendMessage({
    required this.content,
    required this.senderId,
    required this.chatId,
  });
}

class StartMessageSubscription extends ChatEvent {
  final String chatId;

  const StartMessageSubscription({required this.chatId});
}

class StartChatSubscription extends ChatEvent {
  const StartChatSubscription();
}

class StopMessageSubscription extends ChatEvent {
  const StopMessageSubscription();
}

class StopChatSubscription extends ChatEvent {
  const StopChatSubscription();
}

class NewMessageReceived extends ChatEvent {
  final MessageEntity message;
  const NewMessageReceived(this.message);
}
