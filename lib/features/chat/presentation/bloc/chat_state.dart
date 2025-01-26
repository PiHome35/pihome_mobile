import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:equatable/equatable.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

final class ChatLoading extends ChatState {}

final class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatsLoaded(this.chats);
}

final class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  final bool hasMoreMessages;
  final bool isLoadingMore;
  final int currentOffset;

  const MessagesLoaded({
    required this.messages,
    this.hasMoreMessages = true,
    this.isLoadingMore = false,
    this.currentOffset = 0,
  });

  @override
  List<Object?> get props =>
      [messages, hasMoreMessages, isLoadingMore, currentOffset];

  MessagesLoaded copyWith({
    List<MessageEntity>? messages,
    bool? hasMoreMessages,
    bool? isLoadingMore,
    int? currentOffset,
  }) {
    return MessagesLoaded(
      messages: messages ?? this.messages,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentOffset: currentOffset ?? this.currentOffset,
    );
  }
}

class MessageSent extends ChatState {
  final MessageEntity message;
  const MessageSent(this.message);
}

class ChatCreated extends ChatState {
  final ChatEntity chat;
  const ChatCreated(this.chat);
}

class OldMessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const OldMessagesLoaded(this.messages);
}

class OldMessagesLoading extends ChatState {
  const OldMessagesLoading();
}

final class LoadingMoreMessages extends ChatState {
  final List<MessageEntity> currentMessages;

  const LoadingMoreMessages({required this.currentMessages});

  @override
  List<Object?> get props => [currentMessages];
}

final class LoadMoreError extends ChatState {
  final String message;
  final List<MessageEntity> currentMessages;

  const LoadMoreError({
    required this.message,
    required this.currentMessages,
  });

  @override
  List<Object?> get props => [message, currentMessages];
}
