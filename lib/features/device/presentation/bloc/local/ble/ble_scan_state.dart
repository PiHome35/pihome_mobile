import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';

sealed class BleScanState {
  const BleScanState();
}

final class BleScanInitial extends BleScanState {
  const BleScanInitial();
}

final class BleScanInProgress extends BleScanState {
  final List<BleDeviceEntity> devices;

  const BleScanInProgress({required this.devices});
}

final class BleScanComplete extends BleScanState {
  final List<BleDeviceEntity> devices;

  const BleScanComplete({required this.devices});
}

final class BleScanError extends BleScanState {
  final String message;

  const BleScanError({required this.message});
}
