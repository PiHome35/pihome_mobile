import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

sealed class DeviceGroupState {
  const DeviceGroupState();
}

class DeviceGroupInitial extends DeviceGroupState {
  const DeviceGroupInitial();
}

class DeviceGroupLoading extends DeviceGroupState {
  const DeviceGroupLoading();
}

class DeviceGroupsLoaded extends DeviceGroupState {
  final List<DeviceGroupEntity> groups;
  const DeviceGroupsLoaded(this.groups);
}

class DeviceGroupLoaded extends DeviceGroupState {
  final DeviceGroupEntity group;
  const DeviceGroupLoaded(this.group);
}

class DeviceGroupError extends DeviceGroupState {
  final String message;
  const DeviceGroupError(this.message);
}

class DeviceGroupDeleted extends DeviceGroupState {
  const DeviceGroupDeleted();
}

class DevicesInGroupLoaded extends DeviceGroupState {
  final String groupId;
  final List<DeviceEntity> devices;
  const DevicesInGroupLoaded({
    required this.groupId,
    required this.devices,
  });
}

class DeviceAddedToGroup extends DeviceGroupState {
  final String groupId;
  final String deviceId;
  const DeviceAddedToGroup({
    required this.groupId,
    required this.deviceId,
  });
}
