import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';

sealed class DeviceStatusEvent extends Equatable {
  const DeviceStatusEvent();

  @override
  List<Object?> get props => [];
}

class GetDeviceStatus extends DeviceStatusEvent {
  final String deviceId;

  const GetDeviceStatus({
    required this.deviceId,
  });

  @override
  List<Object?> get props => [deviceId];
}

class SetDeviceMuted extends DeviceStatusEvent {
  final String deviceId;
  final bool isMuted;

  const SetDeviceMuted({
    required this.deviceId,
    required this.isMuted,
  });

  @override
  List<Object?> get props => [deviceId, isMuted];
}

class SetDeviceVolume extends DeviceStatusEvent {
  final String deviceId;
  final int volumePercent;

  const SetDeviceVolume({
    required this.deviceId,
    required this.volumePercent,
  });

  @override
  List<Object?> get props => [deviceId, volumePercent];
}

class StartDeviceStatusStream extends DeviceStatusEvent {
  final String deviceId;

  const StartDeviceStatusStream({
    required this.deviceId,
  });

  @override
  List<Object?> get props => [deviceId];
}

class StopDeviceStatusStream extends DeviceStatusEvent {
  const StopDeviceStatusStream();
}

class DeviceHeartbeat extends DeviceStatusEvent {
  final String deviceId;

  const DeviceHeartbeat({
    required this.deviceId,
  });

  @override
  List<Object?> get props => [
        deviceId,
      ];
}

class DeviceStatusStreamConnected extends DeviceStatusEvent {
  const DeviceStatusStreamConnected();
}

class DeviceStatusStreamError extends DeviceStatusEvent {
  final String message;

  const DeviceStatusStreamError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class NewDeviceStatusReceived extends DeviceStatusEvent {
  final DeviceStatusEntity status;

  const NewDeviceStatusReceived({
    required this.status,
  });

  @override
  List<Object?> get props => [status];
}
