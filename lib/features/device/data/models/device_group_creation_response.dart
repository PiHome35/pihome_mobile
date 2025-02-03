import 'package:mobile_pihome/features/device/domain/entities/device_group_entity.dart';

class DeviceGroupCreationResponseModel {
  final String id;
  final String name;
  final String familyId;
  final String createdAt;
  final String updatedAt;
  const DeviceGroupCreationResponseModel({
    required this.id,
    required this.name,
    required this.familyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceGroupCreationResponseModel.fromJson(Map<String, dynamic> json) {
    return DeviceGroupCreationResponseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      familyId: json['familyId'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  factory DeviceGroupCreationResponseModel.fromEntity(DeviceGroupEntity entity) {
    return DeviceGroupCreationResponseModel(
      id: entity.id,
      name: entity.name,
      familyId: entity.familyId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'familyId': familyId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
