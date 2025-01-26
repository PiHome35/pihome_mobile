import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';

abstract class BleScanRepository {
  Stream<List<BleDeviceEntity>> scanForDevices();
  Future<void> stopScan();
}
