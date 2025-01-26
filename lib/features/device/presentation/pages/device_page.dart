import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/device_state.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/device_card.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DeviceBloc>()..add(const FetchDevices()),
      child: const DeviceView(),
    );
  }
}

class DeviceView extends StatelessWidget {
  const DeviceView({super.key});

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
          'Devices',
          style: AppTextStyles.headingMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_outlined),
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
    context.read<DeviceBloc>().add(const FetchDevices());
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadedState(BuildContext context, DeviceLoaded state) {
    if (state.devices.isEmpty) {
      return Center(
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
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DeviceBloc>().add(const FetchDevices());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.devices.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final device = state.devices[index];
          return DeviceCard(device: device);
        },
      ),
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
                context.read<DeviceBloc>().add(const FetchDevices());
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
