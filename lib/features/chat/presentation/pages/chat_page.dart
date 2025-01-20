import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/features/chat/domain/entities/chat.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_event.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_state.dart';
import 'package:mobile_pihome/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:mobile_pihome/core/presentation/widgets/error_state.dart';
import 'package:mobile_pihome/core/graphql/graph_exception.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          final bloc = getIt<UserLocalBloc>();
          bloc.add(const GetCachedUserEvent());
          return bloc;
        }),
        BlocProvider(create: (context) => getIt<ChatBloc>()),
      ],
      child: BlocConsumer<UserLocalBloc, UserLocalState>(
        listener: (context, state) {
          if (state is UserLocalLoaded) {
            context.read<ChatBloc>().add(GetAllChats(
                  familyId: state.user.familyId!,
                  limit: 25,
                ));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Chats',
                style: AppTextStyles.headingMedium,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                AppRoutes.navigateToCreateChatRoom(context);
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                final userState = context.read<UserLocalBloc>().state;
                if (userState is UserLocalLoaded) {
                  context.read<ChatBloc>().add(GetAllChats(
                        familyId: userState.user.familyId!,
                        limit: 25,
                      ));
                }
              },
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return switch (state) {
                    ChatLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ChatError(message: String message) => ErrorStateWidget(
                        error: GraphQLException(
                          message: message,
                          type: GraphQLErrorType.unknown,
                        ),
                        onRetry: () {
                          final userState = context.read<UserLocalBloc>().state;
                          if (userState is UserLocalLoaded) {
                            context.read<ChatBloc>().add(GetAllChats(
                                  familyId: userState.user.familyId!,
                                  limit: 25,
                                ));
                          }
                        },
                      ),
                    ChatsLoaded(chats: List<ChatEntity> chats) =>
                      _buildChatList(chats),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatList(List<ChatEntity> chats) {
    if (chats.isEmpty) {
      return Center(
        child: Text(
          'No chats yet',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatListItem(chat: chat);
      },
    );
  }
}
