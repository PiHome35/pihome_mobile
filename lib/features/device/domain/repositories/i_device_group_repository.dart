import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

abstract class IDeviceGroupRepository {
  Future<DataState<List<DeviceGroupEntity>>> getDeviceGroups({
    required String token,
  });
  Future<DataState<DeviceGroupEntity>> createDeviceGroup({
    required String name,
    required String token,
  });
  Future<DataState<DeviceGroupEntity>> updateDeviceGroup({
    required DeviceGroupEntity group,
    required String token,
  });
  Future<DataState<void>> deleteDeviceGroup({
    required String groupId,
    required String token,
  });
  Future<DataState<DeviceGroupEntity>> getDeviceGroup({
    required String groupId,
    required String token,
  });
  Future<DataState<List<DeviceEntity>>> addDevicesToGroup({
    required String token,
    required String groupId,
    required List<String> deviceIds,
  });
  Future<DataState<List<DeviceEntity>>> removeDevicesFromGroup({
    required String token,
    required String groupId,
    required List<String> deviceIds,
  });
  Future<DataState<List<DeviceEntity>>> getDevicesInGroup({
    required String token,
    required String groupId,
  });
}
