import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/graphql/graphql_config.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_event.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_state.dart';
import 'package:mobile_pihome/features/chat/presentation/widgets/message_bubble.dart';
import 'package:mobile_pihome/core/presentation/widgets/error_state.dart';
import 'package:mobile_pihome/core/graphql/graph_exception.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatId;
  final String? deviceId;
  final String chatName;
  final String familyId;

  const ChatRoomPage({
    super.key,
    required this.chatId,
    this.deviceId,
    required this.chatName,
    required this.familyId,
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
        BlocProvider(
          create: (context) {
            final bloc = getIt<ChatBloc>();
            bloc.add(StartMessageSubscription(chatId: widget.chatId));
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => getIt<SettingBloc>()
            ..add(const GetSettingEvent())
            ..add(const GetChatAiModelsEvent()),
        ),
      ],
      child: BlocProvider(
        create: (context) {
          final bloc = getIt<UserLocalBloc>();
          bloc.add(const GetCachedUserEvent());
          return bloc;
        },
        child: _ChatRoomView(
          chatId: widget.chatId,
          deviceId: widget.deviceId,
          chatName: widget.chatName,
          familyId: widget.familyId,
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
  final String? deviceId;
  final String chatName;
  final String familyId;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final void Function(BuildContext) onSendMessage;
  final VoidCallback onScrollToBottom;

  const _ChatRoomView({
    required this.chatId,
    required this.deviceId,
    required this.chatName,
    required this.familyId,
    required this.messageController,
    required this.scrollController,
    required this.onSendMessage,
    required this.onScrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is MessagesLoaded && deviceId != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatName,
                    style: AppTextStyles.headingMedium,
                  ),
                ],
              );
            }
            return Text(
              chatName,
              style: AppTextStyles.headingMedium,
            );
          },
        ),
        actions: [
          Visibility(
            visible: deviceId == null,
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Delete Chat',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  MinimalDialog.show(
                    context: context,
                    title: 'Delete Chat',
                    message:
                        'Are you sure you want to delete this chat? This action cannot be undone.',
                    primaryButtonText: 'Delete',
                    secondaryButtonText: 'Cancel',
                    type: DialogType.error,
                    icon: Icons.delete_outline_rounded,
                    onPrimaryPressed: () {
                      context.read<ChatBloc>().add(DeleteChat(chatId: chatId));
                      context.pop();
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is MessagesLoaded) {
            // onScrollToBottom();
          }
          if (state is ChatDeleted) {
            MinimalDialog.show(
              context: context,
              title: 'Success',
              message: 'Chat has been deleted successfully',
              primaryButtonText: 'OK',
              showCloseButton: false,
              type: DialogType.success,
              icon: Icons.check_circle_outline_rounded,
              onPrimaryPressed: () {
                context.pop();
                context.pop(true);
                // context.read<ChatBloc>().add(GetAllChats(familyId: familyId));
              },
            );
          }
          if (state is ChatError && state.message.contains('delete')) {
            MinimalDialog.show(
              context: context,
              title: 'Error',
              message: 'Failed to delete chat. Please try again.',
              primaryButtonText: 'OK',
              type: DialogType.error,
              icon: Icons.error_outline_rounded,
              barrierDismissible: false,
              onPrimaryPressed: () {
                context.pop();
              },
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<SettingBloc, SettingState>(
            builder: (context, settingState) {
              log('settingState: $settingState');
              if (state is ChatLoading || settingState is SettingLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ChatError) {
                return ErrorStateWidget(
                  error: GraphQLException(
                    message: state.message,
                    type: GraphQLErrorType.unknown,
                  ),
                  onRetry: () {
                    context.read<ChatBloc>().add(
                          StartMessageSubscription(
                            chatId: chatId,
                          ),
                        );
                  },
                );
              }

              if (settingState is SettingError) {
                return ErrorStateWidget(
                  error: GraphQLException(
                    message: settingState.message,
                    type: GraphQLErrorType.unknown,
                  ),
                  onRetry: () {
                    context.read<SettingBloc>().add(const GetSettingEvent());
                  },
                );
              }

              return GraphQLProvider(
                client: ValueNotifier(GraphQLConfig().client),
                child: GraphQLConsumer(
                  builder: (GraphQLClient client) {
                    return PopScope(
                      onPopInvokedWithResult: (didPop, result) {
                        if (didPop) {
                          context
                              .read<ChatBloc>()
                              .add(const StopMessageSubscription());
                        }
                      },
                      child: Column(
                        children: [
                          if (deviceId != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: _infoChatOfSpeaker(context),
                            ),
                          Expanded(
                            child: Builder(builder: (context) {
                              return switch (state) {
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
                          if (deviceId == null)
                            _buildMessageInput(context)
                          else
                            _buildNotSendMessage(context),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Row _infoChatOfSpeaker(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'This is a chat of speaker',
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Container _buildNotSendMessage(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
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
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Messages cannot be sent in speaker chat',
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
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

    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) {
        if (previous is SettingLoaded && current is SettingLoaded) {
          return previous.chatModels != current.chatModels;
        }
        return false;
      },
      builder: (context, settingState) {
        if (settingState is SettingLoaded) {
         List<String> chatModelsKeyId =
                    settingState.chatModels?.map((e) => e.id).toList() ?? []; 
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
              itemCount: messages.length + (state.isAiTyping ? 1 : 0),
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

                if (state.isAiTyping && index == messages.length) {
                  return _buildAiTypingIndicator(context);
                }

                final message = messages[index];
                bool isAI = false;
                if (chatModelsKeyId.contains(message.senderId)) {
                  isAI = true;
                }
              
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MessageBubble(
                    key: ValueKey(message.id),
                    message: message,
                    isAI: isAI,
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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

  Widget _buildAiTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'AI is typing...',
        style: AppTextStyles.bodySmall.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
