import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_service_entity.dart';

abstract class BleDetailRepository {
  Future<void> connect(BleDeviceEntity device);
  Future<void> disconnect();
  Stream<List<BleServiceEntity>> discoverServices();
  Future<String> readCharacteristic(BleCharacteristicEntity characteristic);
  Future<void> writeCharacteristic(
    BleCharacteristicEntity characteristic,
    String value,
  );
  Future<void> enableNotifications(
    BleCharacteristicEntity characteristic,
    void Function(String value) onValueChanged,
  );
  Future<void> disableNotifications(BleCharacteristicEntity characteristic);
}
