import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';

class DeviceGroupStatusEntity extends Equatable {
  final String id;
  final String name;
  final bool isMuted;
  final List<DeviceStatusEntity> devices;

  const DeviceGroupStatusEntity({
    required this.id,
    required this.name,
    required this.isMuted,
    required this.devices,
  });

  DeviceGroupStatusEntity copyWith({
    String? id,
    String? name,
    bool? isMuted,
    List<DeviceStatusEntity>? devices,
  }) {
    return DeviceGroupStatusEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isMuted: isMuted ?? this.isMuted,
      devices: devices ?? this.devices,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        isMuted,
        devices,
      ];

  @override
  String toString() => 'DeviceGroupStatusEntity('
      'id: $id, '
      'name: $name, '
      'isMuted: $isMuted, '
      'devices: ${devices.length} devices)';
}

class DeviceGroupStatusWithoutDevicesEntity extends Equatable {
  final String id;
  final String name;
  final bool isMuted;

  const DeviceGroupStatusWithoutDevicesEntity({
    required this.id,
    required this.name,
    required this.isMuted,
  });

  DeviceGroupStatusWithoutDevicesEntity copyWith({
    String? id,
    String? name,
    bool? isMuted,
  }) {
    return DeviceGroupStatusWithoutDevicesEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        isMuted,
      ];

  @override
  String toString() => 'DeviceGroupStatusWithoutDevicesEntity('
      'id: $id, '
      'name: $name, '
      'isMuted: $isMuted)';
}
