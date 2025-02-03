import 'package:mobile_pihome/features/device/data/models/device_status_model.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_status_entify.dart';

class DeviceGroupStatusModel extends DeviceGroupStatusEntity {
  const DeviceGroupStatusModel({
    required super.id,
    required super.name,
    required super.isMuted,
    required super.devices,
  });

  factory DeviceGroupStatusModel.fromJson(Map<String, dynamic> json) {
    return DeviceGroupStatusModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isMuted: json['isMuted'] as bool,
      devices: (json['devices'] as List<dynamic>)
          .map((device) =>
              DeviceStatusModel.fromJson(device as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isMuted': isMuted,
      'devices': devices
          .map((device) => (device as DeviceStatusModel).toJson())
          .toList(),
    };
  }

  DeviceGroupStatusEntity toEntity() {
    return DeviceGroupStatusEntity(
      id: id,
      name: name,
      isMuted: isMuted,
      devices: devices,
    );
  }
}

class DeviceGroupStatusWithoutDevicesModel
    extends DeviceGroupStatusWithoutDevicesEntity {
  const DeviceGroupStatusWithoutDevicesModel({
    required super.id,
    required super.name,
    required super.isMuted,
  });

  factory DeviceGroupStatusWithoutDevicesModel.fromJson(
      Map<String, dynamic> json) {
    return DeviceGroupStatusWithoutDevicesModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isMuted: json['isMuted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isMuted': isMuted,
    };
  }
}
