import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pihome/config/di/injection.dart';
import 'package:mobile_pihome/config/routes/routes.dart';
import 'package:mobile_pihome/config/themes/text_styles.dart';
import 'package:mobile_pihome/core/widgets/minimal_dialog.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_service_entity.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_detail/ble_detail_bloc.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_detail/ble_detail_event.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_detail/ble_detail_state.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDetailPage extends StatelessWidget {
  final BleDeviceEntity device;

  const DeviceDetailPage({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<BleDetailBloc>()..add(ConnectToDevice(device: device)),
      child: DeviceDetailView(device: device),
    );
  }
}

class DeviceDetailView extends StatefulWidget {
  final BleDeviceEntity device;

  const DeviceDetailView({
    super.key,
    required this.device,
  });

  @override
  State<DeviceDetailView> createState() => _DeviceDetailViewState();
}

class _DeviceDetailViewState extends State<DeviceDetailView> {
  late BleDetailBloc _bleDetailBloc;
  StreamSubscription? _bluetoothStateSubscription;

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bleDetailBloc = context.read<BleDetailBloc>();
  }

  @override
  void dispose() {
    _bluetoothStateSubscription?.cancel();
    _bleDetailBloc.add(const DisconnectDevice());
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
          'Your Bluetooth has been turned off. Please enable Bluetooth to maintain connection with your PiHome device. The device details cannot be accessed without an active Bluetooth connection.',
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
          widget.device.name,
          style: AppTextStyles.headingMedium,
        ),
      ),
      body: BlocBuilder<BleDetailBloc, BleDetailState>(
        builder: (context, state) {
          return switch (state) {
            BleDetailInitial() => _buildConnectingState(),
            BleDetailConnecting() => _buildConnectingState(),
            BleDetailConnected() => _buildConnectedState(context, state),
            BleDetailError() => _buildErrorState(context, state),
          };
        },
      ),
    );
  }

  Widget _buildConnectingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Connecting to device...'),
        ],
      ),
    );
  }

  Widget _buildConnectedState(BuildContext context, BleDetailConnected state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.services.length,
      itemBuilder: (context, index) {
        final service = state.services[index];
        return _buildServiceCard(context, service);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, BleServiceEntity service) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            'Service: ${service.uuid}',
            style: AppTextStyles.labelMedium,
          ),
          children: service.characteristics.map((characteristic) {
            return ListTile(
              title: Text(
                'Characteristic: ${characteristic.uuid}',
                style: AppTextStyles.bodyMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Properties: ${_getCharacteristicProperties(characteristic)}',
                    style: AppTextStyles.bodySmall,
                  ),
                  if (characteristic.value != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Value: ${characteristic.value}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (characteristic.canRead)
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _bleDetailBloc.add(
                        ReadCharacteristic(characteristic: characteristic),
                      ),
                    ),
                  if (characteristic.canWrite)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showWriteDialog(context, characteristic),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getCharacteristicProperties(BleCharacteristicEntity characteristic) {
    final properties = <String>[];
    if (characteristic.canRead) properties.add('Read');
    if (characteristic.canWrite) properties.add('Write');
    if (characteristic.canNotify) properties.add('Notify');
    return properties.join(', ');
  }

  void _showWriteDialog(
    BuildContext context,
    BleCharacteristicEntity characteristic,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Write Value',
          style: AppTextStyles.headingSmall,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter value',
            hintStyle: AppTextStyles.inputHint,
            border: const OutlineInputBorder(),
          ),
          style: AppTextStyles.input,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium,
            ),
          ),
          FilledButton(
            onPressed: () {
              _bleDetailBloc.add(
                WriteCharacteristic(
                  characteristic: characteristic,
                  value: controller.text,
                ),
              );
              Navigator.pop(context);
            },
            child: Text(
              'Write',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, BleDetailError state) {
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
              'Connection Error',
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () {
                _bleDetailBloc.add(ConnectToDevice(device: widget.device));
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
