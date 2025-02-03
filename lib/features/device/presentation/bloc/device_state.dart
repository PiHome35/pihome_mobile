import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

sealed class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object?> get props => [];
}

final class DeviceInitial extends DeviceState {
  const DeviceInitial();
}

final class DeviceLoading extends DeviceState {
  const DeviceLoading();
}

final class DeviceLoaded extends DeviceState {
  final List<DeviceEntity> devices;
  final List<DeviceGroupEntity> deviceGroups;

  const DeviceLoaded({
    required this.devices,
    required this.deviceGroups,
  });

  @override
  List<Object?> get props => [
        devices,
      ];
}

final class DeviceError extends DeviceState {
  final String message;

  const DeviceError(this.message);

  @override
  List<Object> get props => [message];
}
