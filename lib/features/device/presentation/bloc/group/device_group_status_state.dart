import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';

sealed class DeviceGroupStatusState extends Equatable {
  const DeviceGroupStatusState();

  @override
  List<Object?> get props => [];
}

class DeviceGroupStatusInitial extends DeviceGroupStatusState {
  const DeviceGroupStatusInitial();
}

class DeviceGroupStatusLoading extends DeviceGroupStatusState {
  const DeviceGroupStatusLoading();
}

class DeviceGroupStatusSuccess extends DeviceGroupStatusState {
  final DeviceGroupStatusEntity data;

  const DeviceGroupStatusSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class DeviceGroupStatusError extends DeviceGroupStatusState {
  final String message;

  const DeviceGroupStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeviceGroupStatusStreamConnecting extends DeviceGroupStatusState {
  const DeviceGroupStatusStreamConnecting();
}

class DeviceGroupStatusStreamDisconnected extends DeviceGroupStatusState {
  final String reason;

  const DeviceGroupStatusStreamDisconnected(this.reason);

  @override
  List<Object?> get props => [reason];
}
