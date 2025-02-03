import 'package:equatable/equatable.dart';

class DeviceStatusEntity extends Equatable {
  final String id;
  final String macAddress;
  final String name;
  final bool isOn;
  final bool isMuted;
  final int volumePercent;
  final bool isSoundServer;

  const DeviceStatusEntity({
    required this.id,
    required this.macAddress,
    required this.name,
    required this.isOn,
    required this.isMuted,
    required this.volumePercent,
    required this.isSoundServer,
  });

  @override
  List<Object?> get props => [
        id,
        macAddress,
        name,
        isOn,
        isMuted,
        volumePercent,
        isSoundServer,
      ];
}
