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
          style: AppTextStyles.headingMedium,
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
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildScanningState(BuildContext context, BleScanInProgress state) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const LinearProgressIndicator(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildDeviceList(context, state.devices),
        ),
      ],
    );
  }

  Widget _buildCompleteState(BuildContext context, BleScanComplete state) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: _buildDeviceList(context, state.devices),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.tonal(
            onPressed: () {
              _bleScanBloc.add(const StartScan());
            },
            child: Text(
              'Scan Again',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, BleScanError state) {
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
              'Scanning Error',
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
                _bleScanBloc.add(const StartScan());
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

  Widget _buildDeviceList(BuildContext context, List<BleDeviceEntity> devices) {
    final theme = Theme.of(context);

    if (devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_searching,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Searching for PiHome devices...',
              style: AppTextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: devices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final device = devices[index];
        return BleDeviceCard(device: device);
      },
    );
  }
}
