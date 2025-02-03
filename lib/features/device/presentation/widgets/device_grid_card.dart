import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/group/device_group_status_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/group/device_group_status_state.dart';

class DeviceGridCard extends StatelessWidget {
  final DeviceEntity device;
  final Function(bool) onToggle;
  final DeviceGroupStatusBloc deviceGroupStatusBloc;

  const DeviceGridCard({
    super.key,
    required this.device,
    required this.onToggle,
    required this.deviceGroupStatusBloc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<DeviceGroupStatusBloc, DeviceGroupStatusState>(
      bloc: deviceGroupStatusBloc,
      listener: (context, state) {
        log('state: $state');
      },
      builder: (context, state) {
        if (state is DeviceGroupStatusSuccess) {
          final deviceStatus = state.data.devices.firstWhere(
            (element) => element.id == device.id,
          );
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                AppRoutes.navigateToDeviceDetail(context, device);
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDeviceIcon(theme, deviceStatus.isMuted),
                    const SizedBox(height: 12),
                    _buildDeviceName(theme),
                    const SizedBox(height: 2),
                    _buildVolumeText(theme, deviceStatus.volumePercent),
                    const SizedBox(height: 8),
                    _buildMuteButton(theme, deviceStatus.isMuted),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDeviceIcon(ThemeData theme, bool isMuted) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: device.isOn
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Icon(
          isMuted ? Icons.speaker : Icons.speaker,
          size: 28,
          color: device.isOn
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.outline,
        ),
        if (isMuted)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.volume_off_rounded,
                size: 12,
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeviceName(ThemeData theme) {
    return Text(
      device.name,
      style: AppTextStyles.labelMedium.copyWith(
        color: theme.colorScheme.onSurface,
        height: 1.2,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildVolumeText(ThemeData theme, int volumePercent) {
    return Text(
      'Volume: $volumePercent%',
      style: AppTextStyles.deviceType.copyWith(
        color: theme.colorScheme.outline,
      ),
    );
  }

  Widget _buildMuteButton(ThemeData theme, bool isMuted) {
    return IconButton(
      onPressed: () {
        onToggle(!isMuted);
      },
      icon: Icon(
        isMuted ? Icons.volume_off : Icons.volume_up,
        size: 24,
        color:
            device.isOn ? theme.colorScheme.primary : theme.colorScheme.outline,
      ),
      style: IconButton.styleFrom(
        backgroundColor: device.isOn
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
