import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

abstract class IDeviceGroupRepository {
  Future<DataState<List<DeviceGroupEntity>>> getDeviceGroups();
  Future<DataState<DeviceGroupEntity>> createDeviceGroup(
      DeviceGroupEntity group);
  Future<DataState<DeviceGroupEntity>> updateDeviceGroup(
      DeviceGroupEntity group);
  Future<DataState<void>> deleteDeviceGroup(String groupId);
  Future<DataState<DeviceGroupEntity>> getDeviceGroup(String groupId);
}
