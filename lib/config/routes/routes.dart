import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/login_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/register_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/splash_page.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_event.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/chat_room_page.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/create_chat_room_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_group_page.dart';
import 'package:mobile_pihome/features/family/presentation/pages/create_family_page.dart';
import 'package:mobile_pihome/features/landing/presentation/pages/landing_page.dart';
import 'package:mobile_pihome/features/loading/presentation/pages/loading_page.dart';
import 'package:mobile_pihome/success_login.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/chat_page.dart';
import 'package:mobile_pihome/features/family/presentation/pages/join_family_page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const success = '/success';
  static const home = '/home';
  static const createFamily = '/create-family';
  static const setting = '/setting';
  static const chats = '/chats';
  static const createChatRoom = '/chat/create';
  static const device = '/device';
  static const landing = '/landing';
  static const deviceGroups = '/device-groups';
  static const loading = '/loading';
  static const chatRoom = '/chat/:chatId';
  static const joinFamily = '/join-family';

  static final router = GoRouter(
    initialLocation: splash,
    routes: <RouteBase>[
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: success,
        builder: (context, state) => const LoginSuccess(),
      ),
      GoRoute(
        path: createFamily,
        builder: (context, state) => const CreateFamilyPage(),
      ),
      GoRoute(
        path: landing,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: deviceGroups,
        builder: (context, state) =>
            const DeviceGroupPage(familyId: 'family-001'),
      ),
      GoRoute(
        path: loading,
        builder: (context, state) => const LoadingPageProvider(),
      ),
      GoRoute(
        path: createChatRoom,
        builder: (context, state) => const CreateChatRoomPage(),
      ),
      GoRoute(
        path: '/chats',
        builder: (context, state) => const ChatPage(),
      ),
      GoRoute(
        path: '/chat/:chatId',
        builder: (context, state) => ChatRoomPage(
          chatId: state.pathParameters['chatId']!,
        ),
      ),
      GoRoute(
        path: joinFamily,
        builder: (context, state) => const JoinFamilyPage(),
      ),
    ],
  );

  static void navigateToChatRoom(
    BuildContext context,
    String chatId,
    String userId,
    String chatName,
    List<MessageEntity> messages,
  ) {
    context.push(
      chatRoom.replaceFirst(':chatId', chatId),
      extra: ChatRoomPage(
        chatId: chatId,
      ),
    );
  }

  static void navigateToCreateChatRoom(BuildContext context) {
    context.push(createChatRoom);
  }
}
