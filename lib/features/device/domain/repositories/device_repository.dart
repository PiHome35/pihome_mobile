import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

abstract class DeviceRepository {
  Future<DataState<List<DeviceEntity>>> getDevices({required String token});
  Future<DataState<DeviceEntity>> getCurrentDevice({required String token});
  Future<DataState<DeviceEntity>> getDeviceById(
      {required String deviceId, required String token});
  Future<DataState<void>> deleteDevice({required String deviceId, required String token});
  Future<DataState<DeviceEntity>> updateDevice({
    required String name,
    required String deviceId,
    required String token,
  });
  Future<void> cacheDevices(List<DeviceEntity> devices);
  Future<void> deleteCachedDevices();
  Future<void> updateCachedDevice(DeviceEntity device);
  Future<List<DeviceEntity>> getCachedDevices();
}
