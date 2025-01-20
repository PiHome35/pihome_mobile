import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/features/device/data/models/device_group_model.dart';

abstract class DeviceGroupMockDatasource {
  Future<List<DeviceGroupModel>> getDeviceGroups();
  Future<DeviceGroupModel> createDeviceGroup(DeviceGroupModel group);
  Future<DeviceGroupModel> updateDeviceGroup(DeviceGroupModel group);
  Future<void> deleteDeviceGroup(String groupId);
  Future<DeviceGroupModel> getDeviceGroup(String groupId);
}

@Environment('mock')
@LazySingleton(as: DeviceGroupMockDatasource)
class DeviceGroupMockDataSourceImpl implements DeviceGroupMockDatasource {
  final List<DeviceGroupModel> _mockGroups = [
    DeviceGroupModel(
      id: '1',
      name: 'Living Room',
      familyId: 'family1',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      icon: 'living_room',
      deviceIds: ['device1', 'device2'],
    ),
    DeviceGroupModel(
      id: '2',
      name: 'Kitchen',
      familyId: 'family1',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      icon: 'kitchen',
      deviceIds: ['device3'],
    ),
  ];

  @override
  Future<List<DeviceGroupModel>> getDeviceGroups() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockGroups;
  }

  @override
  Future<DeviceGroupModel> createDeviceGroup(DeviceGroupModel group) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newGroup = DeviceGroupModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: group.name,
      familyId: group.familyId,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      icon: group.icon,
      deviceIds: group.deviceIds,
    );
    _mockGroups.add(newGroup);
    return newGroup;
  }

  @override
  Future<DeviceGroupModel> updateDeviceGroup(DeviceGroupModel group) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockGroups.indexWhere((g) => g.id == group.id);
    if (index == -1) {
      throw Exception('Group not found');
    }
    final updatedGroup = DeviceGroupModel(
      id: group.id,
      name: group.name,
      familyId: group.familyId,
      createdAt: group.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
      icon: group.icon,
      deviceIds: group.deviceIds,
    );
    _mockGroups[index] = updatedGroup;
    return updatedGroup;
  }

  @override
  Future<void> deleteDeviceGroup(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockGroups.removeWhere((g) => g.id == groupId);
  }

  @override
  Future<DeviceGroupModel> getDeviceGroup(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final group = _mockGroups.firstWhere(
      (g) => g.id == groupId,
      orElse: () => throw Exception('Group not found'),
    );
    return group;
  }
}
