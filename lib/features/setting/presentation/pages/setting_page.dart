import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_bloc.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_event.dart';
import 'package:mobile_pihome/features/family/presentation/bloc/family_setting/family_setting_state.dart';
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
          create: (context) =>
              getIt<SettingBloc>()..add(const GetSettingEvent()),
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
            // showSnackBar(context, state.message);
            log('[SettingPage] state: $state');
          }
        },
        builder: (context, state) {
          if (state is SettingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingError) {
            return Center(
              child: Text(
                state.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          }

          if (state is SettingLoaded) {
            final setting = state.setting;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FamilySettingsSection(
                  familyName: setting.familyName ?? '',
                ),
                const AccountSettingsSection(),
                const AIModelSettingsSection(),
                IntegrationsSettingsSection(setting: setting),
              ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
