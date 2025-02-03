import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble/ble_scan_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble/ble_scan_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble/ble_scan_state.dart';
import 'package:mobile_pihome/features/device/presentation/widgets/ble_device_card.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceScanPage extends StatelessWidget {
  const DeviceScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BleScanBloc>()..add(const StartScan()),
      child: const DeviceScanView(),
    );
  }
}

class DeviceScanView extends StatefulWidget {
  const DeviceScanView({super.key});

  @override
  State<DeviceScanView> createState() => _DeviceScanViewState();
}

class _DeviceScanViewState extends State<DeviceScanView> {
  late BleScanBloc _bleScanBloc;
  StreamSubscription? _bluetoothStateSubscription;

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bleScanBloc = context.read<BleScanBloc>();
  }

  @override
  void dispose() {
    _bluetoothStateSubscription?.cancel();
    _bleScanBloc.add(const StopScan());
    super.dispose();
  }

  void _checkBluetoothState() {
    _bluetoothStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state != BluetoothAdapterState.on && mounted) {
        _showBluetoothErrorDialog();
      }
    });
  }

  void _showBluetoothErrorDialog() {
    MinimalDialog.show(
      context: context,
      title: 'Bluetooth Disconnected',
      message:
          'Your Bluetooth has been turned off. Please enable Bluetooth to scan for PiHome devices. Device scanning cannot proceed without an active Bluetooth connection.',
      primaryButtonText: 'Go Back',
      type: DialogType.error,
      icon: Icons.bluetooth_disabled,
      onPrimaryPressed: () {
        context.go(AppRoutes.landing);
      },
      showCloseButton: false,
    );
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
          'Scan Devices',
          style: AppTextStyles.headingMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: BlocConsumer<BleScanBloc, BleScanState>(
        listener: (context, state) {
          log("in device scan: ${state.runtimeType}");
          if (state is BleScanError && state.message.contains('bluetooth')) {
            _showBluetoothErrorDialog();
          }
        },
        builder: (context, state) {
          return switch (state) {
            BleScanInitial() => _buildInitialState(),
            BleScanInProgress() => _buildScanningState(context, state),
            BleScanComplete() => _buildCompleteState(context, state),
            BleScanError() => _buildErrorState(context, state),
          };
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildScanningState(BuildContext context, BleScanInProgress state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: .1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Scanning for devices...',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Make sure your PiHome device is powered on and nearby',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bluetooth_searching_rounded,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Searching nearby...',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Looking for PiHome devices in range',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteState(BuildContext context, BleScanComplete state) {
    final theme = Theme.of(context);
    final bool devicesFound = state.devices.isNotEmpty;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: .1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  devicesFound
                      ? Icons.bluetooth_rounded
                      : Icons.bluetooth_disabled_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                devicesFound
                    ? '${state.devices.length} ${state.devices.length == 1 ? 'device' : 'devices'} found'
                    : 'No devices found',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildDeviceList(context, state.devices),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
                blurRadius: 24,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _bleScanBloc.add(const StartScan());
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.refresh_rounded, size: 20),
                  ),
                  label: Text(devicesFound ? 'Scan Again' : 'Retry Scan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceList(BuildContext context, List<BleDeviceEntity> devices) {
    final theme = Theme.of(context);

    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bluetooth_disabled_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No PiHome devices found',
              style: AppTextStyles.headingSmall.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Make sure your device is powered on\nand within range',
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: devices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final device = devices[index];
        return BleDeviceCard(device: device);
      },
    );
  }

  Widget _buildErrorState(BuildContext context, BleScanError state) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Scanning Error',
              style: AppTextStyles.headingSmall.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _bleScanBloc.add(const StartScan());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
