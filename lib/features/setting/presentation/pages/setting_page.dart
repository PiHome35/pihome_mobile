import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/account_settings_section.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/ai_model_settings_section.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/family_settings_section.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/integrations_settings_section.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<UserLocalBloc>()..add(const GetCachedUserEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<SettingBloc>()
            ..add(const GetSettingEvent())
            ..add(const GetChatAiModelsEvent()),
        ),
      ],
      child: const SettingView(),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: AppTextStyles.headingMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingError) {
            log('[SettingPage] state: $state');
          }
        },
        builder: (context, state) {
          final userState = context.read<UserLocalBloc>().state;
          if (state is SettingLoading && userState is UserLocalLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<SettingBloc>().add(const GetSettingEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SettingLoaded && userState is UserLocalLoaded) {
            final setting = state.setting;
            final chatModels = state.chatModels;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SettingBloc>()
                  ..add(const GetSettingEvent())
                  ..add(const GetChatAiModelsEvent());
                context.read<UserLocalBloc>().add(const GetCachedUserEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FamilySettingsSection(
                      familyName: setting.familyName ?? '',
                      userId: userState.user.id,
                    ),
                    const AccountSettingsSection(),
                    AIModelSettingsSection(
                      chatModels: chatModels ?? [],
                      settingBloc: context.read<SettingBloc>(),
                    ),
                    IntegrationsSettingsSection(setting: setting),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
