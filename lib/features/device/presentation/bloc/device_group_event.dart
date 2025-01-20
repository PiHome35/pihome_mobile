import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

sealed class DeviceGroupEvent {
  const DeviceGroupEvent();
}

class GetDeviceGroupsEvent extends DeviceGroupEvent {
  const GetDeviceGroupsEvent();
}

class CreateDeviceGroupEvent extends DeviceGroupEvent {
  final DeviceGroupEntity group;
  const CreateDeviceGroupEvent(this.group);
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
