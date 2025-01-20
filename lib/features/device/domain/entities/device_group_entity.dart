import 'package:equatable/equatable.dart';

class DeviceGroupEntity extends Equatable {
  final String id;
  final String name;
  final String familyId;
  final String createdAt;
  final String updatedAt;
  final String? icon;
  final List<String> deviceIds;

  const DeviceGroupEntity({
    required this.id,
    required this.name,
    required this.familyId,
    required this.createdAt,
    required this.updatedAt,
    this.icon,
    required this.deviceIds,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        familyId,
        createdAt,
        updatedAt,
        icon,
        deviceIds,
      ];
}
