import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/graphql/graphql_config.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_event.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_state.dart';
import 'package:mobile_pihome/features/chat/presentation/widgets/message_bubble.dart';
import 'package:mobile_pihome/core/presentation/widgets/error_state.dart';
import 'package:mobile_pihome/core/graphql/graph_exception.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatId;

  const ChatRoomPage({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;
      final isAtTop = _scrollController.position.pixels == 0;

      if (isAtBottom || isAtTop) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }
  }

  void _sendMessage(BuildContext context) {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final userState = context.read<UserLocalBloc>().state;
    if (userState is UserLocalLoaded) {
      context.read<ChatBloc>().add(SendMessage(
            content: message,
            senderId: userState.user.id,
            chatId: widget.chatId,
          ));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<ChatBloc>();
        bloc.add(StartMessageSubscription(chatId: widget.chatId));
        return bloc;
      },
      child: BlocProvider(
        create: (context) {
          final bloc = getIt<UserLocalBloc>();
          bloc.add(const GetCachedUserEvent());
          return bloc;
        },
        child: _ChatRoomView(
          chatId: widget.chatId,
          messageController: _messageController,
          scrollController: _scrollController,
          onSendMessage: _sendMessage,
          onScrollToBottom: _scrollToBottom,
        ),
      ),
    );
  }
}

class _ChatRoomView extends StatelessWidget {
  final String chatId;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final void Function(BuildContext) onSendMessage;
  final VoidCallback onScrollToBottom;

  const _ChatRoomView({
    required this.chatId,
    required this.messageController,
    required this.scrollController,
    required this.onSendMessage,
    required this.onScrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Room',
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is MessagesLoaded) {
            onScrollToBottom();
          }
        },
        builder: (context, state) {
          return GraphQLProvider(
            client: ValueNotifier(GraphQLConfig().client),
            child: GraphQLConsumer(
              builder: (GraphQLClient client) {
                return PopScope(
                  onPopInvokedWithResult: (didPop, result) {
                    log('onPopInvokedWithResult: $didPop, $result');
                    if (didPop) {
                      context
                          .read<ChatBloc>()
                          .add(const StopMessageSubscription());
                    }
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Builder(builder: (context) {
                          return switch (state) {
                            ChatLoading() => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ChatError(message: String message) =>
                              ErrorStateWidget(
                                error: GraphQLException(
                                  message: message,
                                  type: GraphQLErrorType.unknown,
                                ),
                                onRetry: () {
                                  context.read<ChatBloc>().add(
                                        StartMessageSubscription(
                                          chatId: chatId,
                                        ),
                                      );
                                },
                              ),
                            MessagesLoaded() =>
                              BlocBuilder<UserLocalBloc, UserLocalState>(
                                builder: (context, userState) {
                                  if (userState is UserLocalLoaded) {
                                    return _buildMessageList(
                                      context,
                                      state.messages,
                                      state,
                                      userState.user.id,
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            _ => const SizedBox.shrink(),
                          };
                        }),
                      ),
                      _buildMessageInput(context),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageList(
    BuildContext context,
    List<MessageEntity> messages,
    MessagesLoaded state,
    String currentUserId,
  ) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (messages.isNotEmpty) {
          context.read<ChatBloc>().add(LoadMoreMessages(
                chatId: chatId,
                lastMessageId: messages.first.id,
                pageSize: 20,
              ));
        }
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          if (index == 0 && state.isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final message = messages[index];
          final isMe = currentUserId == message.senderId;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: MessageBubble(
              key: ValueKey(message.id),
              message: message,
              isMe: isMe,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                style: AppTextStyles.input,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: AppTextStyles.inputHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSendMessage(context),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => onSendMessage(context),
              icon: Icon(
                Icons.send_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
