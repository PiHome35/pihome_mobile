import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';

sealed class DeviceStatusState extends Equatable {
  const DeviceStatusState();

  @override
  List<Object?> get props => [];
}

class DeviceStatusInitial extends DeviceStatusState {
  const DeviceStatusInitial();
}

class DeviceStatusLoading extends DeviceStatusState {
  const DeviceStatusLoading();
}

class DeviceStatusSuccess extends DeviceStatusState {
  final DeviceStatusEntity status;

  const DeviceStatusSuccess(this.status);

  @override
  List<Object?> get props => [status];
}

class DeviceStatusError extends DeviceStatusState {
  final String message;

  const DeviceStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeviceStatusStreamConnecting extends DeviceStatusState {
  const DeviceStatusStreamConnecting();
}

class DeviceStatusStreamDisconnected extends DeviceStatusState {
  final String? reason;

  const DeviceStatusStreamDisconnected([this.reason]);

  @override
  List<Object?> get props => [reason];
}
