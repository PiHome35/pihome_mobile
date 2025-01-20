import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

abstract class DeviceRepository {
  Future<List<DeviceEntity>> getDevices();
  Future<void> cacheDevices(List<DeviceEntity> devices);
  Future<void> deleteCachedDevices();
  Future<void> updateCachedDevice(DeviceEntity device);
  Future<List<DeviceEntity>> getCachedDevices();
}
