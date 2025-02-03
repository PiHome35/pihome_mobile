import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

sealed class DeviceGroupEvent {
  const DeviceGroupEvent();
}

class GetDeviceGroupsEvent extends DeviceGroupEvent {
  const GetDeviceGroupsEvent();
}

class CreateDeviceGroupEvent extends DeviceGroupEvent {
  final String name;
  final List<String> deviceIds;
  const CreateDeviceGroupEvent(this.name, this.deviceIds);
}

class UpdateDeviceGroupEvent extends DeviceGroupEvent {
  final DeviceGroupEntity group;
  const UpdateDeviceGroupEvent(this.group);
}

class DeleteDeviceGroupEvent extends DeviceGroupEvent {
  final String groupId;
  const DeleteDeviceGroupEvent(this.groupId);
}

class GetDeviceGroupEvent extends DeviceGroupEvent {
  final String groupId;
  const GetDeviceGroupEvent(this.groupId);
}

class GetDevicesInGroupEvent extends DeviceGroupEvent {
  final String groupId;
  const GetDevicesInGroupEvent(this.groupId);
}

class AddDeviceToGroupEvent extends DeviceGroupEvent {
  final String groupId;
  final List<String> deviceIds;
  const AddDeviceToGroupEvent({
    required this.groupId,
    required this.deviceIds,
  });
}
