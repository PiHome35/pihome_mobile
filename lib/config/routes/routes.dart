import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/login_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/register_page.dart';
import 'package:mobile_pihome/features/authentication/presentation/pages/splash_page.dart';
import 'package:mobile_pihome/features/chat/domain/entities/message.dart';
import 'package:mobile_pihome/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/chat_room_page.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/create_chat_room_page.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/presentation/pages/bluetooth_check_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_ble_detail_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_ble_setup_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_group_creation_page.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_group_page.dart';
import 'package:mobile_pihome/features/family/domain/entities/chat_ai_entity.dart';
import 'package:mobile_pihome/features/family/presentation/pages/create_family_page.dart';
import 'package:mobile_pihome/features/family/presentation/pages/family_settings_page.dart';
import 'package:mobile_pihome/features/landing/presentation/pages/landing_page.dart';
import 'package:mobile_pihome/features/loading/presentation/pages/loading_page.dart';
import 'package:mobile_pihome/features/chat/presentation/pages/chat_page.dart';
import 'package:mobile_pihome/features/family/presentation/pages/join_family_page.dart';
import 'dart:async';
import 'package:mobile_pihome/features/device/presentation/pages/device_scan_page.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_group_detail_page.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/presentation/pages/device_detail_page.dart';
import 'package:mobile_pihome/features/setting/presentation/pages/setting_ai_model_selection.dart';

class ChatRoomExtra {
  final String chatId;
  final String? deviceId;
  final String chatName;
  final String familyId;
  ChatRoomExtra({
    required this.chatId,
    this.deviceId,
    required this.chatName,
    required this.familyId,
  });
}

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
  static const deviceBleDetail = '/device/ble/detail';
  static const deviceSetup = '/device/setup';
  static const deviceGroupDetail = '/device-groups/:groupId';
  static const deviceDetail = '/device/detail';
  static const aiModelSelection = '/setting/ai-model';
  static const deviceGroupCreation = '/device-groups/create';
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
        path: '/device-groups/create',
        builder: (context, state) {
          final extra = state.extra as String;
          return DeviceGroupCreationPage(
            familyId: extra,
          );
        },
      ),
      GoRoute(
        path: '/chat/:chatId',
        builder: (context, state) {
          final extra = state.extra as ChatRoomExtra;
          return ChatRoomPage(
            chatId: extra.chatId,
            deviceId: extra.deviceId,
            chatName: extra.chatName,
            familyId: extra.familyId,
          );
        },
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
        path: deviceBleDetail,
        builder: (context, state) => DeviceBleDetailPage(
          device: state.extra as BleDeviceEntity,
        ),
      ),
      GoRoute(
        path: deviceSetup,
        builder: (context, state) => DeviceBleSetupPage(
          device: state.extra as BleDeviceEntity,
        ),
      ),
      GoRoute(
        path: deviceGroupDetail,
        builder: (context, state) => DeviceGroupDetailPage(
          group: state.extra as DeviceGroupEntity,
        ),
      ),
      GoRoute(
        path: deviceDetail,
        builder: (context, state) => DeviceDetailPage(
          device: state.extra as DeviceEntity,
        ),
      ),
      GoRoute(
        path: aiModelSelection,
        builder: (context, state) {
          final extra = state.extra as List<ChatAiModelEntity>;
          return AIModelSelectionPage(chatModels: extra);
        },
      ),
    ],
  );

  static void navigateToFamilySettings(BuildContext context) {
    context.push(familySettings);
  }

  static Future<bool> navigateToChatRoom(
    BuildContext context,
    String chatId,
    String? deviceId,
    String chatName,
    String familyId,
  ) async {
    final bool? isDeleteChat = await context.push(
      chatRoom.replaceFirst(':chatId', chatId),
      extra: ChatRoomExtra(
        chatId: chatId,
        deviceId: deviceId,
        chatName: chatName,
        familyId: familyId,
      ),
    );
    return isDeleteChat ?? false;
  }

  static Future<bool> navigateToCreateChatRoom(BuildContext context) {
    return context.push<bool>(createChatRoom).then((value) => value ?? false);
  }

  static void navigateToDeviceBleDetail(
      BuildContext context, BleDeviceEntity device) {
    context.push(deviceBleDetail, extra: device);
  }

  static void navigateToDeviceDetail(
      BuildContext context, DeviceEntity device) {
    context.push(deviceDetail, extra: device);
  }

  static void navigateToDeviceSetup(
      BuildContext context, BleDeviceEntity device) {
    context.push(deviceSetup, extra: device);
  }

  static Future<bool> navigateToDeviceGroupDetail(
      BuildContext context, DeviceGroupEntity group) {
    return context.push<bool>(
      deviceGroupDetail.replaceFirst(':groupId', group.id),
      extra: group,
    ).then((value) => value ?? false);
  }

  static void navigateToAIModelSelection(BuildContext context, List<ChatAiModelEntity> chatModels) {
    context.push(aiModelSelection, extra: chatModels);
  }

  static Future<bool> navigateToDeviceGroupCreation(
      BuildContext context, String familyId) {
    return context.push<bool>(
      deviceGroupCreation,
      extra: familyId,
    ).then((value) => value ?? false);
  }
}
