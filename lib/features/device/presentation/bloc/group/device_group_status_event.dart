import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';

sealed class DeviceGroupStatusEvent extends Equatable {
  const DeviceGroupStatusEvent();

  @override
  List<Object?> get props => [];
}

class GetDeviceGroupStatus extends DeviceGroupStatusEvent {
  final String groupId;

  const GetDeviceGroupStatus({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class SetGroupMuted extends DeviceGroupStatusEvent {
  final String groupId;
  final bool isMuted;

  const SetGroupMuted({
    required this.groupId,
    required this.isMuted,
  });

  @override
  List<Object?> get props => [groupId, isMuted];
}

class StartGroupStatusStream extends DeviceGroupStatusEvent {
  final String groupId;

  const StartGroupStatusStream({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

class StopGroupStatusStream extends DeviceGroupStatusEvent {
  const StopGroupStatusStream();
}

class NewGroupStatusReceived extends DeviceGroupStatusEvent {
  final DeviceGroupStatusEntity status;

  const NewGroupStatusReceived({required this.status});

  @override
  List<Object?> get props => [status];
}

