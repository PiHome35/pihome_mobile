import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/group/device_group_status_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/group/device_group_status_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/group/device_group_status_state.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_state.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/status/device_status_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/status/device_status_event.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/device_grid_card.dart';

class DeviceGroupDetailPage extends StatelessWidget {
  final DeviceGroupEntity group;

  const DeviceGroupDetailPage({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<DeviceGroupBloc>(),
        ),
        BlocProvider(create: (context) => getIt<DeviceStatusBloc>()),
        BlocProvider(create: (context) => getIt<DeviceGroupStatusBloc>()),
      ],
      child: DeviceGroupDetailView(group: group),
    );
  }
}

class DeviceGroupDetailView extends StatefulWidget {
  final DeviceGroupEntity group;

  const DeviceGroupDetailView({
    super.key,
    required this.group,
  });

  @override
  State<DeviceGroupDetailView> createState() => _DeviceGroupDetailViewState();
}

class _DeviceGroupDetailViewState extends State<DeviceGroupDetailView> {
  late final DeviceGroupStatusBloc _groupStatusBloc;
  late final DeviceGroupBloc _deviceGroupBloc;
  late final DeviceStatusBloc _deviceStatusBloc;

  @override
  void initState() {
    super.initState();
    _groupStatusBloc = context.read<DeviceGroupStatusBloc>();
    _deviceGroupBloc = context.read<DeviceGroupBloc>();
    _deviceStatusBloc = context.read<DeviceStatusBloc>();

    _deviceGroupBloc.add(GetDevicesInGroupEvent(widget.group.id));
    _groupStatusBloc.add(GetDeviceGroupStatus(groupId: widget.group.id));
    _groupStatusBloc.add(StartGroupStatusStream(groupId: widget.group.id));
  }

  @override
  void dispose() {
    _groupStatusBloc.add(const StopGroupStatusStream());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.group.name,
          style: AppTextStyles.headingSmall.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          _popupMenuButton(theme, context),
        ],
      ),
      body: BlocConsumer<DeviceGroupStatusBloc, DeviceGroupStatusState>(
        listener: (context, stateGroupDeviceStatus) {
          log('new state deviceGroupStatus >>>>>> : $stateGroupDeviceStatus');
          if (stateGroupDeviceStatus is DeviceGroupStatusError) {
            MinimalDialog.show(
              context: context,
              title: 'Error',
              message: 'Failed to load group status',
              primaryButtonText: 'OK',
              onPrimaryPressed: () {
                context.pop();
              },
            );
          }
        },
        builder: (context, stateGroupDeviceStatus) {
          return Column(
            children: [
              Expanded(
                child: BlocBuilder<DeviceGroupBloc, DeviceGroupState>(
                  builder: (context, state) {
                    if (state is DeviceGroupLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is DeviceGroupError) {
                      return _buildGroupError(theme);
                    }

                    if (state is DeviceGroupLoaded &&
                        state.group.devices.isEmpty) {
                      return _buildDeviceGroupEmpty(theme);
                    }

                    if (state is DevicesInGroupLoaded) {
                      return _buildGroupLoaded(state, stateGroupDeviceStatus);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupLoaded(
      DevicesInGroupLoaded stateGroup, DeviceGroupStatusState stateStatus) {
    final theme = Theme.of(context);
    bool isMuted = false;
    bool canPress = false;

    if (stateStatus is DeviceGroupStatusSuccess) {
      isMuted = stateStatus.data.isMuted;
      canPress = true;
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: stateGroup.devices.length,
            itemBuilder: (context, index) {
              final device = stateGroup.devices[index];
              return DeviceGridCard(
                deviceGroupStatusBloc: _groupStatusBloc,
                device: device,
                onToggle: (value) {
                  _deviceStatusBloc.add(
                    SetDeviceMuted(
                      deviceId: device.id,
                      isMuted: value,
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: canPress
                  ? () {
                      _groupStatusBloc.add(
                        SetGroupMuted(
                          groupId: widget.group.id,
                          isMuted: !isMuted,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isMuted
                    ? theme.colorScheme.errorContainer
                    : theme.colorScheme.primaryContainer,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!canPress)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isMuted
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
                    ),
                  if (!canPress) const SizedBox(width: 12),
                  if (canPress)
                    Icon(
                      isMuted
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                      color: isMuted
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    canPress
                        ? (isMuted ? 'Unmute All Devices' : 'Mute All Devices')
                        : 'Loading...',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isMuted
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuButton<String> _popupMenuButton(
      ThemeData theme, BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_rounded,
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 12),
              Text(
                'Edit Group',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_rounded,
                size: 20,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                'Delete Group',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            // TODO: Implement edit functionality
            break;
          case 'delete':
            MinimalDialog.show(
              context: context,
              title: 'Delete Group',
              message:
                  'Are you sure you want to delete "${widget.group.name}" group? This action cannot be undone.',
              primaryButtonText: 'Delete',
              secondaryButtonText: 'Cancel',
              type: DialogType.error,
              onPrimaryPressed: () {
                _deviceGroupBloc.add(DeleteDeviceGroupEvent(widget.group.id));
                context.pop();
                context.pop(true);
              },
            );
            break;
        }
      },
    );
  }

  Center _buildDeviceGroupEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices_rounded,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No devices in this group',
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Center _buildGroupError(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load devices',
            style: AppTextStyles.bodyLarge.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _deviceGroupBloc.add(GetDevicesInGroupEvent(widget.group.id));
            },
            child: Text(
              'Retry',
              style: AppTextStyles.buttonMedium.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
