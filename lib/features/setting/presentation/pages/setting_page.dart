import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_bloc.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_event.dart';
import 'package:mobile_pihome/core/presentation/bloc/local/user_local_state.dart';
import 'package:mobile_pihome/core/services/spotify_auth_service.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_item.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_section.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SettingBloc>()),
        BlocProvider(create: (context) => getIt<UserLocalBloc>()),
      ],
      child: const SettingView(),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  void _handleSpotifyConnection(
      BuildContext context, SettingEntity setting) async {
    final spotifyAuthService = getIt<SpotifyAuthService>();

    if (setting.isSpotifyConnected) {
      // Handle disconnect
      final confirmed = await MinimalDialog.show(
        context: context,
        title: 'Disconnect Spotify',
        message: 'Are you sure you want to disconnect your Spotify account?',
        primaryButtonText: 'Disconnect',
        secondaryButtonText: 'Cancel',
        type: DialogType.caution,
      );

      if (confirmed == true) {
        await spotifyAuthService.logout();
        if (context.mounted) {
          context.read<SettingBloc>().add(
                UpdateSettingEvent(
                  SettingEntity(
                    userEmail: setting.userEmail,
                    selectedLLMModel: setting.selectedLLMModel,
                    isSpotifyConnected: false,
                  ),
                ),
              );
        }
      }
    } else {
      // Handle connect - Show dialog for first-time connection
      final confirmed = await MinimalDialog.show(
        context: context,
        title: 'Connect Spotify',
        message:
            'You will be redirected to Spotify to authorize access to your account. This allows PiHome to control your music playback.',
        primaryButtonText: 'Continue',
        secondaryButtonText: 'Cancel',
        type: DialogType.normal,
        icon: Icons.music_note_rounded,
      );

      if (confirmed == true) {
        // Handle connect
        final success = await spotifyAuthService.authenticate();
        if (success && context.mounted) {
          context.read<SettingBloc>().add(
                UpdateSettingEvent(
                  SettingEntity(
                    userEmail: setting.userEmail,
                    selectedLLMModel: setting.selectedLLMModel,
                    isSpotifyConnected: true,
                  ),
                ),
              );

          // Show success dialog
          if (context.mounted) {
            await MinimalDialog.show(
              context: context,
              title: 'Successfully Connected',
              message: 'Your Spotify account has been connected to PiHome.',
              primaryButtonText: 'OK',
              type: DialogType.success,
              showCloseButton: false,
            );
          }
        } else if (context.mounted) {
          // Show error dialog
          await MinimalDialog.show(
            context: context,
            title: 'Connection Failed',
            message: 'Failed to connect to Spotify. Please try again.',
            primaryButtonText: 'OK',
            type: DialogType.error,
            showCloseButton: false,
          );
        }
      }
    }
  }

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
      body: BlocBuilder<UserLocalBloc, UserLocalState>(
        builder: (context, state) {
          if (state is UserLocalInitial) {
            context.read<UserLocalBloc>().add(const GetCachedUserEvent());
            return const Center(child: CircularProgressIndicator());
          }
    
          if (state is SettingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
    
          if (state is UserLocalError) {
            return Center(
              child: Text(
                state.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            );
          }
    
          if (state is UserLocalLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingSection(
                    title: 'Family',
                    child: SettingItem(
                      title: 'Family Name',
                      subtitle: state.user.name,
                      trailing: const Icon(
                        Icons.chevron_right,
                        size: 20,
                      ),
                      onTap: () {
                        
                      },
                    ),
                  ),
                  SettingSection(
                    title: 'Account',
                    child: BlocBuilder<UserLocalBloc, UserLocalState>(
                      builder: (context, state) {
                        String email = '';
                        if (state is UserLocalInitial) {
                          context
                              .read<UserLocalBloc>()
                              .add(const GetCachedUserEvent());
                        } else if (state is UserLocalLoaded) {
                          email = state.user.email;
                        } else {
                          log('[getLocalUser] state: $state');
                        }
                        return SettingItem(
                          title: 'Email',
                          subtitle: email,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.logout,
                              size: 20,
                            ),
                            onPressed: () {
                              // TODO: Implement logout
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SettingSection(
                    title: 'AI Model',
                    child: SettingItem(
                      title: 'Selected Model',
                      subtitle: "GPT-4o",
                      trailing: const Icon(
                        Icons.chevron_right,
                        size: 20,
                      ),
                      onTap: () {
                        // TODO: Implement model selection
                      },
                    ),
                  ),
                  SettingSection(
                    title: 'Integrations',
                    child: SettingItem(
                      title: 'Spotify',
                      subtitle: "Connected",
                      trailing: Switch.adaptive(
                        value: true,
                        onChanged: (value) {
                          log('value: $value');
                          _handleSpotifyConnection(context, state.user);
                        },
                      ),
                    ),
                  ),
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
