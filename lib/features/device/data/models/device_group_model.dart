import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

class DeviceGroupModel extends DeviceGroupEntity {
  const DeviceGroupModel({
    required super.id,
    required super.name,
    required super.familyId,
    required super.createdAt,
    required super.updatedAt,
    super.icon,
    required super.deviceIds,
  });

  factory DeviceGroupModel.fromJson(Map<String, dynamic> json) {
    return DeviceGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      familyId: json['familyId'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      icon: json['icon'] as String?,
      deviceIds:
          (json['deviceIds'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'familyId': familyId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'icon': icon,
      'deviceIds': deviceIds,
    };
  }

  DeviceGroupEntity toEntity() => this;
}
