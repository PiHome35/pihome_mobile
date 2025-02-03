import 'package:flutter/material.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/status/device_status_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/status/device_status_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/status/device_status_state.dart';

class DeviceDetailPage extends StatefulWidget {
  final DeviceEntity device;

  const DeviceDetailPage({
    super.key,
    required this.device,
  });

  @override
  State<DeviceDetailPage> createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  late final DeviceStatusBloc _deviceStatusBloc;

  @override
  void initState() {
    super.initState();
    _deviceStatusBloc = getIt<DeviceStatusBloc>();
    _deviceStatusBloc.add(StartDeviceStatusStream(deviceId: widget.device.id));
  }

  @override
  void dispose() {
    if (!_deviceStatusBloc.isClosed) {
      _deviceStatusBloc.add(const StopDeviceStatusStream());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _deviceStatusBloc,
      child: DeviceDetailView(device: widget.device),
    );
  }
}

class DeviceDetailView extends StatelessWidget {
  final DeviceEntity device;

  const DeviceDetailView({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceStatusBloc, DeviceStatusState>(
      listener: (context, state) {
        if (state is DeviceStatusStreamDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Device status stream disconnected.")),
          );
        }
      },
      builder: (context, state) {
        final deviceStatus = state is DeviceStatusSuccess ? state.status : null;
        final theme = Theme.of(context);
        if (state is DeviceStatusLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            final bloc = context.read<DeviceStatusBloc>();
            if (!bloc.isClosed) {
              bloc.add(const StopDeviceStatusStream());
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Device Details',
                style: AppTextStyles.headingSmall,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Header
                    _deviceHeader(theme, deviceStatus),
                    const SizedBox(height: 32),

                    // Controls Section
                    Text(
                      'Controls',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _cardControls(theme, deviceStatus, context),
                    const SizedBox(height: 32),

                    // Device Info Section
                    Text(
                      'Device Information',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _cardDeviceInformation(theme),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Card _cardDeviceInformation(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('MAC Address', device.macAddress),
            const Divider(),
            _buildInfoRow('Client ID', device.clientId),
            if (device.deviceGroupId != null) ...[
              const Divider(),
              _buildInfoRow('Group', device.deviceGroupId!),
            ],
            const Divider(),
            _buildInfoRow(
              'Sound Server',
              device.isSoundServer ? 'Yes' : 'No',
            ),
          ],
        ),
      ),
    );
  }

  Card _cardControls(
      ThemeData theme, DeviceStatusEntity? deviceStatus, BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mute Switch
            SwitchListTile(
              title: Text(
                'Mute',
                style: AppTextStyles.labelMedium,
              ),
              value: deviceStatus?.isMuted ?? device.isMuted,
              onChanged: (value) {
                context.read<DeviceStatusBloc>().add(
                      SetDeviceMuted(
                        deviceId: device.id,
                        isMuted: value,
                      ),
                    );
              },
            ),
            const Divider(),
            // Volume Slider
            ListTile(
              title: Text(
                'Volume',
                style: AppTextStyles.labelMedium,
              ),
              subtitle: Slider(
                value: deviceStatus?.volumePercent.toDouble() ??
                    device.volumePercent.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label:
                    '${deviceStatus?.volumePercent ?? device.volumePercent}%',
                onChanged: (value) {
                  context.read<DeviceStatusBloc>().add(
                        SetDeviceVolume(
                          deviceId: device.id,
                          volumePercent: value.toInt(),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _deviceHeader(ThemeData theme, DeviceStatusEntity? deviceStatus) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: device.isOn
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.speaker,
                  size: 32,
                  color: device.isOn
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
              ),
              if (deviceStatus?.isMuted ?? device.isMuted)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_off_rounded,
                      size: 14,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.name,
                style: AppTextStyles.headingSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: device.isOn
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    device.isOn ? 'Online' : 'Offline',
                    style: AppTextStyles.deviceType.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (deviceStatus?.isMuted ?? device.isMuted) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.volume_off_rounded,
                            size: 14,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Muted',
                            style: AppTextStyles.deviceType.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.end,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
