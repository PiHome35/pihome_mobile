import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/core/services/spotify_auth_service.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/setting/domain/entities/setting_entity.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_pihome/features/setting/presentation/bloc/setting_state.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_item.dart';
import 'package:mobile_pihome/features/setting/presentation/widgets/setting_section.dart';

class IntegrationsSettingsSection extends StatelessWidget {
  const IntegrationsSettingsSection({super.key, required this.setting});

  final SettingEntity setting;

  void _handleSpotifyConnection(BuildContext context) async {
    // final spotifyAuthService = getIt<SpotifyAuthService>();
    log('setting: ${setting.isSpotifyConnected}');
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
        if (context.mounted) {
          context.read<SettingBloc>().add(
                const LogoutSpotifyConnectEvent(),
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
        if (context.mounted) {
          context.read<SettingBloc>().add(
                const CreateSpotifyConnectEvent(),
              );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingSection(
      title: 'Integrations',
      child: SettingItem(
        title: 'Spotify',
        subtitle: setting.isSpotifyConnected ? 'Connected' : 'Not Connected',
        trailing: Switch.adaptive(
          value: setting.isSpotifyConnected,
          onChanged: (value) {
            _handleSpotifyConnection(
              context,
            );
          },
        ),
      ),
    );
  }
}
