import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/data/datasources/ble_local_datasource.dart';
import 'package:mobile_pihome/features/device/data/models/ble_device_model.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_device_entity.dart';
import 'package:mobile_pihome/features/device/domain/repositories/ble_scan_repository.dart';

@LazySingleton(as: BleScanRepository)
class BleScanRepositoryImpl implements BleScanRepository {
  final BleLocalDataSource _bleLocalDataSource;

  BleScanRepositoryImpl(this._bleLocalDataSource);

  @override
  Stream<List<BleDeviceEntity>> scanForDevices() {
    return _bleLocalDataSource.scanDevices().map((devices) {
      return devices
          .where((device) => device.platformName
              .toLowerCase()
              .startsWith('pihome'.toLowerCase()))
          .map((device) {
        return BleDeviceModel(
          id: device.remoteId.toString(),
          name: device.platformName,
          rssi: -1, // Default value until we get actual RSSI
          device: device,
        );
      }).toList();
    });
  }

  @override
  Future<void> stopScan() {
    return _bleLocalDataSource.stopScan();
  }
}
