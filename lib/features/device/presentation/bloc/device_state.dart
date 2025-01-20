import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

sealed class DeviceState {
  const DeviceState();
}

final class DeviceInitial extends DeviceState {
  const DeviceInitial();
}

final class DeviceLoading extends DeviceState {
  const DeviceLoading();
}

final class DeviceLoaded extends DeviceState {
  final List<DeviceEntity> devices;
  const DeviceLoaded(this.devices);
}

final class DeviceError extends DeviceState {
  final String message;
  const DeviceError(this.message);
}
