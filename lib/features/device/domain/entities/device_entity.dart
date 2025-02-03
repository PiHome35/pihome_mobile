import 'package:equatable/equatable.dart';

typedef StatusDevice = int;

abstract class StatusDevices {
  static const StatusDevice on = 1;
  static const StatusDevice off = 0;
}

class DeviceEntity extends Equatable {
  final String id;
  final String clientId;
  final String macAddress;
  final String name;
  final String familyId;
  final String? deviceGroupId;
  final String createdAt;
  final String updatedAt;
  final bool isOn;
  final bool isMuted;
  final int volumePercent;
  final bool isSoundServer;

  const DeviceEntity({
    required this.id,
    required this.clientId,
    required this.macAddress,
    required this.name,
    required this.familyId,
    this.deviceGroupId,
    required this.createdAt,
    required this.updatedAt,
    required this.isOn,
    required this.isMuted,
    required this.volumePercent,
    required this.isSoundServer,
  });

  @override
  List<Object?> get props => [
        id,
        clientId,
        macAddress,
        name,
        familyId,
        deviceGroupId,
        createdAt,
        updatedAt,
        isOn,
        isMuted,
        volumePercent,
        isSoundServer,
      ];
}
