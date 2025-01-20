import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';

sealed class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatsLoaded(this.chats);
}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded(this.messages);
}

class MessageSent extends ChatState {
  final MessageEntity message;
  const MessageSent(this.message);
}

class ChatCreated extends ChatState {
  final ChatEntity chat;
  const ChatCreated(this.chat);
}
