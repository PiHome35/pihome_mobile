import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/core/widgets/custom_button.dart';
import 'package:mobile_pihome/core/widgets/custom_text_field.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_event.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_state.dart';

class CreateChatRoomPage extends StatefulWidget {
  const CreateChatRoomPage({super.key});

  @override
  State<CreateChatRoomPage> createState() => _CreateChatRoomPageState();
}

class _CreateChatRoomPageState extends State<CreateChatRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final _chatNameController = TextEditingController();

  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<UserLocalBloc>()..add(const GetCachedUserEvent()),
        ),
        BlocProvider(create: (context) => getIt<ChatBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Chat Room',
            style: AppTextStyles.headingSmall,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatCreated) {
              context.pop();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Chat Room',
                      style: AppTextStyles.headingMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a new chat room to start conversations with your family members.',
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _chatNameController,
                      label: 'Chat Room Name',
                      hintText: 'Enter chat room name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a chat room name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<UserLocalBloc, UserLocalState>(
                      builder: (context, state) {
                        log('User state: $state');
                        return CustomButton(
                          onPressed: () {
                            final userState =
                                context.read<UserLocalBloc>().state;
                            if (userState is UserLocalLoaded) {
                              log('Creating new chat room');
                              context.read<ChatBloc>().add(
                                    CreateNewChat(
                                      familyId: userState.user.familyId!,
                                    ),
                                  );
                            }
                          },
                          text: 'Create Room',
                          width: double.infinity,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
