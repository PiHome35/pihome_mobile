import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          final bloc = getIt<ChatBloc>();
          bloc.add(StartMessageSubscription(chatId: widget.chatId));
          return bloc;
        }),
        BlocProvider(create: (context) {
          final bloc = getIt<UserLocalBloc>();
          bloc.add(const GetCachedUserEvent());
          return bloc;
        }),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat Room',
            style: AppTextStyles.headingMedium,
          ),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            log('state in chat room: $state');
            if (state is MessagesLoaded) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            return PopScope(
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  context.read<ChatBloc>().add(const StopMessageSubscription());
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
                                        chatId: widget.chatId,
                                      ),
                                    );
                              },
                            ),
                          MessagesLoaded(
                            messages: List<MessageEntity> messages
                          ) =>
                            _buildMessageList(messages),
                          _ => const SizedBox.shrink(),
                      };
                    }),
                  ),
                  _buildMessageInput(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageList(List<MessageEntity> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final userState = context.read<UserLocalBloc>().state;
        bool isMe = false;
        if (userState is UserLocalLoaded) {
          isMe = userState.user.id == message.senderId;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: MessageBubble(
            key: ValueKey(message.id),
            message: message,
            isMe: isMe,
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return BlocBuilder<UserLocalBloc, UserLocalState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
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
                    controller: _messageController,
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
                    onSubmitted: (_) => _sendMessage(context),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _sendMessage(context),
                  icon: Icon(
                    Icons.send_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
