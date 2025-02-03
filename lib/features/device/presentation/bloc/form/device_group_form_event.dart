import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

abstract class DeviceGroupFormEvent extends Equatable {
  const DeviceGroupFormEvent();

  @override
  List<Object?> get props => [];
}

class UpdateNameEvent extends DeviceGroupFormEvent {
  final String name;

  const UpdateNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class ToggleDeviceEvent extends DeviceGroupFormEvent {
  final DeviceEntity device;

  const ToggleDeviceEvent(this.device);

  @override
  List<Object> get props => [device];
}

class ValidateFormEvent extends DeviceGroupFormEvent {}
