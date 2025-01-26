import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/bluetooth/bluetooth_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/bluetooth/bluetooth_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/bluetooth/bluetooth_state.dart';

class BluetoothCheckPage extends StatelessWidget {
  const BluetoothCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BluetoothBloc>()..add(const CheckBluetoothStatus()),
      child: const BluetoothCheckView(),
    );
  }
}

class BluetoothCheckView extends StatelessWidget {
  const BluetoothCheckView({super.key});

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
          'Bluetooth Setup',
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: BlocConsumer<BluetoothBloc, BluetoothState>(
        listener: (context, state) {
          if (state is BluetoothReady) {
            context.pushReplacement('/scan-device');
          }
        },
        builder: (context, state) {
          return switch (state) {
            BluetoothInitial() => _buildInitialState(context),
            BluetoothLoading() => _buildLoadingState(),
            BluetoothPermissionDenied() => _buildPermissionDeniedState(context),
            BluetoothDisabled() => _buildBluetoothDisabledState(context),
            BluetoothReady() => _buildReadyState(),
            BluetoothError() => _buildErrorState(context, state),
          };
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    context.read<BluetoothBloc>().add(const CheckBluetoothStatus());
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildPermissionDeniedState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_disabled,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Bluetooth Permission Required',
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please grant Bluetooth permission to scan for devices',
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () {
                context
                    .read<BluetoothBloc>()
                    .add(const RequestBluetoothPermission());
              },
              child: Text(
                'Grant Permission',
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothDisabledState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_disabled,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Bluetooth is Disabled',
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please enable Bluetooth to scan for devices',
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () {
                context.read<BluetoothBloc>()
                  ..add(const RequestBluetoothPermission())
                  ..add(const EnableBluetooth());
              },
              child: Text(
                'Enable Bluetooth',
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadyState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(BuildContext context, BluetoothError state) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () {
                context.read<BluetoothBloc>().add(const CheckBluetoothStatus());
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
