import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_service_entity.dart';

sealed class BleDetailEvent {
  const BleDetailEvent();
}

final class ConnectToDevice extends BleDetailEvent {
  final BleDeviceEntity device;

  const ConnectToDevice({required this.device});
}

final class DisconnectDevice extends BleDetailEvent {
  const DisconnectDevice();
}

final class ReadCharacteristic extends BleDetailEvent {
  final BleCharacteristicEntity characteristic;

  const ReadCharacteristic({required this.characteristic});
}

final class WriteCharacteristic extends BleDetailEvent {
  final BleCharacteristicEntity characteristic;
  final String value;

  const WriteCharacteristic({
    required this.characteristic,
    required this.value,
  });
}

final class ToggleNotification extends BleDetailEvent {
  final BleCharacteristicEntity characteristic;
  final bool enabled;

  const ToggleNotification({
    required this.characteristic,
    required this.enabled,
  });
}
