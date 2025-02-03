import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

sealed class LocalDeviceEvent {
  const LocalDeviceEvent();
}

final class GetCachedDevices extends LocalDeviceEvent {
  const GetCachedDevices();
}

final class UpdateCachedDevice extends LocalDeviceEvent {
  final DeviceEntity device;

  const UpdateCachedDevice(this.device);
}

final class DeleteCachedDevices extends LocalDeviceEvent {
  const DeleteCachedDevices();
}

final class CacheDevices extends LocalDeviceEvent {
  final List<DeviceEntity> devices;

  const CacheDevices(this.devices);
}
