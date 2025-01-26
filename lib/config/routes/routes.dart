import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/login_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/register_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/splash_page.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/chat_room_page.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/create_chat_room_page.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/presentation/pages/bluetooth_check_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_detail_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_group_page.dart';
import 'package:mobile_pihome/features/family/presentation/pages/create_family_page.dart';
import 'package:mobile_pihome/features/family/presentation/pages/family_settings_page.dart';
import 'package:mobile_pihome/features/landing/presentation/pages/landing_page.dart';
import 'package:mobile_pihome/features/loading/presentation/pages/loading_page.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/chat_page.dart';
import 'package:mobile_pihome/features/family/presentation/pages/join_family_page.dart';
import 'dart:async';
import 'package:mobile_pihome/features/device/presentation/pages/device_scan_page.dart';

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
  static const familySettings = '/family-settings';
  static const bluetoothCheck = '/bluetooth-check';
  static const scanDevice = '/scan-device';
  static const deviceDetail = '/device/detail';

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
      GoRoute(
        path: familySettings,
        builder: (context, state) => const FamilySettingsPage(),
      ),
      GoRoute(
        path: bluetoothCheck,
        builder: (context, state) => const BluetoothCheckPage(),
      ),
      GoRoute(
        path: scanDevice,
        builder: (context, state) => const DeviceScanPage(),
      ),
      GoRoute(
        path: deviceDetail,
        builder: (context, state) => DeviceDetailPage(
          device: state.extra as BleDeviceEntity,
        ),
      ),
    ],
  );

  static void navigateToFamilySettings(BuildContext context) {
    context.push(familySettings);
  }

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

  static Future<bool> navigateToCreateChatRoom(BuildContext context) {
    return context.push<bool>(createChatRoom).then((value) => value ?? false);
  }
}
