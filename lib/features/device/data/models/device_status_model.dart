import 'package:mobile_pihome/features/device/domain/entities/device_status_entity.dart';

class DeviceStatusModel extends DeviceStatusEntity {
  const DeviceStatusModel({
    required super.id,
    required super.macAddress,
    required super.name,
    required super.isOn,
    required super.isMuted,
    required super.volumePercent,
    required super.isSoundServer,
  });

  factory DeviceStatusModel.fromJson(Map<String, dynamic> json) {
    return DeviceStatusModel(
      id: json['id'] as String,
      macAddress: json['macAddress'] as String,
      name: json['name'] as String,
      isOn: json['isOn'] as bool,
      isMuted: json['isMuted'] as bool,
      volumePercent: json['volumePercent'] as int,
      isSoundServer: json['isSoundServer'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'macAddress': macAddress,
      'name': name,
      'isOn': isOn,
      'isMuted': isMuted,
      'volumePercent': volumePercent,
      'isSoundServer': isSoundServer,
    };
  }

  DeviceStatusEntity toEntity() {
    return DeviceStatusEntity(
      id: id,
      macAddress: macAddress,
      name: name,
      isOn: isOn,
      isMuted: isMuted,
      volumePercent: volumePercent,
      isSoundServer: isSoundServer,
    );
  }

  DeviceStatusModel copyWith({
    String? id,
    String? macAddress,
    String? name,
    bool? isOn,
    bool? isMuted,
    int? volumePercent,
    bool? isSoundServer,
  }) {
    return DeviceStatusModel(
      id: id ?? this.id,
      macAddress: macAddress ?? this.macAddress,
      name: name ?? this.name,
      isOn: isOn ?? this.isOn,
      isMuted: isMuted ?? this.isMuted,
      volumePercent: volumePercent ?? this.volumePercent,
      isSoundServer: isSoundServer ?? this.isSoundServer,
    );
  }
}
