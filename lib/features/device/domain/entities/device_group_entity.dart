import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

class DeviceGroupEntity extends Equatable {
  final String id;
  final String name;
  final String familyId;
  final String createdAt;
  final String updatedAt;
  final List<DeviceEntity> devices;

  const DeviceGroupEntity({
    required this.id,
    required this.name,
    required this.familyId,
    required this.createdAt,
    required this.updatedAt,
    this.devices = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        familyId,
        createdAt,
        updatedAt,
        devices,
      ];
}
