import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

class DeviceGroupModel extends DeviceGroupEntity {
  const DeviceGroupModel({
    required super.id,
    required super.name,
    required super.familyId,
    required super.createdAt,
    required super.updatedAt,
    required super.devices,
  });


  factory DeviceGroupModel.fromEntity(DeviceGroupEntity entity) {
    return DeviceGroupModel(
      id: entity.id,
      name: entity.name,
      familyId: entity.familyId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      devices: entity.devices,
    );
  }

  factory DeviceGroupModel.fromJson(Map<String, dynamic> json) {
    return DeviceGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      familyId: json['familyId'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      devices: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'familyId': familyId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'devices': devices,
    };
  }

  DeviceGroupModel addDevices({required List<DeviceEntity> devices}) {
    return DeviceGroupModel(
      id:  id,
      name: name,
      familyId: familyId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      devices: devices,
    );
  }

  DeviceGroupModel copyWith({
    String? id,
    String? name,
    String? familyId,
    String? createdAt,
    String? updatedAt,
    List<DeviceEntity>? devices,
  }) {
    return DeviceGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      familyId: familyId ?? this.familyId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      devices: devices ?? this.devices,
    );
  }
}
