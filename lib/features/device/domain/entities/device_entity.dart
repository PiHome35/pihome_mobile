import 'package:equatable/equatable.dart';

typedef StatusDevice = int;

abstract class StatusDevices {
  static const StatusDevice on = 1;
  static const StatusDevice off = 0;
}

class DeviceEntity extends Equatable {
  final String id;
  final String name;
  final String familyId;
  final String? groupId;
  final String createdAt;
  final String updatedAt;
  final bool isOn;

  const DeviceEntity({
    required this.id,
    required this.name,
    required this.familyId,
    this.groupId,
    required this.createdAt,
    required this.updatedAt,
    required this.isOn,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        familyId,
        groupId,
        createdAt,
        updatedAt,
        isOn,
      ];
}
