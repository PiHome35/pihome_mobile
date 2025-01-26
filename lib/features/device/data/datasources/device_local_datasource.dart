import 'package:mobile_pihome/core/error/exception.dart';
import 'package:mobile_pihome/core/utils/cache/hive_manager.dart';
import 'package:mobile_pihome/features/device/data/models/device_model.dart';

abstract class DeviceLocalDataSource {
  Future<List<DeviceModel>> getCachedDevices();
  Future<void> cacheDevices(List<DeviceModel> devices);
  Future<void> deleteCachedDevices();
  Future<void> updateCachedDevice(DeviceModel device);
}

// @LazySingleton(as: DeviceLocalDataSource)
class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final HiveManager _hiveManager;
  DeviceLocalDataSourceImpl(this._hiveManager);

  @override
  Future<void> cacheDevices(List<DeviceModel> devices) async {
    for (DeviceModel device in devices) {
      try {
        await _hiveManager.deviceBox.put(device.id, device);
      } catch (e) {
        throw CacheException(e.toString());
      }
    }
  }

  @override
  Future<void> deleteCachedDevices() async {
    try {
      await _hiveManager.deviceBox.clear();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<DeviceModel>> getCachedDevices() async {
    List<DeviceModel> devices = _hiveManager.deviceBox.values.toList();
    return devices;
  }

  @override
  Future<void> updateCachedDevice(DeviceModel device) async {
    try {
      await _hiveManager.deviceBox.put(device.id, device);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
