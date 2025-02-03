import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';

class BleDeviceModel extends BleDeviceEntity {
  const BleDeviceModel({
    required super.id,
    required super.name,
    required super.rssi,
    required super.device,
  });

  BleDeviceEntity toEntity() {
    return BleDeviceEntity(
      id: id,
      name: name,
      rssi: rssi,
      device: device,
    );
  }
}
