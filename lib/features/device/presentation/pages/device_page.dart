import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_state.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/device_local_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/device_local_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/remote/group/device_group_event.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/device_card.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/device_group_card.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<DeviceBloc>()..add(const GetDevices()),
        ),
        BlocProvider(
          create: (context) => getIt<LocalDeviceBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<DeviceGroupBloc>()..add(const GetDeviceGroupsEvent()),
        ),
      ],
      child: const DeviceView(),
    );
  }
}

class DeviceView extends StatelessWidget {
  const DeviceView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final deviceBloc = context.read<DeviceBloc>();
    // final deviceGroupBloc = context.read<DeviceGroupBloc>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Devices',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.devices_other),
            onPressed: () {
              context.push('/device-groups');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/bluetooth-check');
            },
          ),
        ],
      ),
      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          return switch (state) {
            DeviceInitial() => _buildInitialState(context),
            DeviceLoading() => _buildLoadingState(),
            DeviceLoaded() => _buildLoadedState(context, state),
            DeviceError() => _buildErrorState(context, state),
          };
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    context.read<DeviceBloc>().add(const GetDevices());
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedState(BuildContext context, DeviceLoaded state) {
    final localDeviceBloc = context.read<LocalDeviceBloc>();
    final deviceBloc = context.read<DeviceBloc>();
    localDeviceBloc.add(const GetCachedDevices());
    final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    Widget buildEmptyState() {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.devices_other,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No devices found',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a new device',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget buildDeviceList(DeviceBloc deviceBloc) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Ungrouped Devices',
            style: AppTextStyles.labelLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (state.devices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.speaker,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No ungrouped devices',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...state.devices.map((device) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DeviceCard(device: device),
              );
            }),
          const SizedBox(height: 24),
          Text(
            'Device Groups',
            style: AppTextStyles.labelLarge.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          if (state.deviceGroups.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.speaker_group,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No device groups',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...state.deviceGroups.map((group) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DeviceGroupCard(
                    group: group,
                    onTap: () async {
                      final bool isDeleteGroup =
                          await AppRoutes.navigateToDeviceGroupDetail(
                              context, group);
                      if (isDeleteGroup) {
                        deviceBloc.add(const GetDevices());
                        
                      }
                    },
                  ),
                )),
        ],
      );
    }

    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        context.read<DeviceBloc>().add(const GetDevices());
      },
      child: state.devices.isEmpty && state.deviceGroups.isEmpty
          ? buildEmptyState()
          : buildDeviceList(deviceBloc),
    );
  }

  Widget _buildErrorState(BuildContext context, DeviceError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                context.read<DeviceBloc>().add(const GetDevices());
              },
              child: Text(
                'Try Again',
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
