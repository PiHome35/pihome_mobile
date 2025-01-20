import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

sealed class LocalDeviceState {
  const LocalDeviceState();
}

final class LocalDeviceInitial extends LocalDeviceState {
  const LocalDeviceInitial();
}

final class LocalDeviceLoading extends LocalDeviceState {
  const LocalDeviceLoading();
}

final class LocalDeviceLoaded extends LocalDeviceState {
  final List<DeviceEntity> devices;
  const LocalDeviceLoaded(this.devices);
}

final class LocalDeviceCached extends LocalDeviceState {
  final List<DeviceEntity> devices;
  const LocalDeviceCached(this.devices);
}

final class LocalDeviceUpdated extends LocalDeviceState {
  final DeviceEntity device;
  const LocalDeviceUpdated(this.device);
}

final class LocalDeviceDeleted extends LocalDeviceState {
  const LocalDeviceDeleted();
}

final class LocalDeviceError extends LocalDeviceState {
  final String message;
  const LocalDeviceError(this.message);
}
