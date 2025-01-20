import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
part 'device_model.g.dart';

@HiveType(typeId: 0)
class DeviceModel {
  
  @HiveField(0)
  // @override
  final String id;

  @HiveField(1)
  // @override
  final String name;

  @HiveField(2)
  // @override
  final String familyId;

  @HiveField(3)
  // @override
  final String createdAt;

  @HiveField(4)
  // @override
  final String updatedAt;

  @HiveField(5)
  // @override
  final String? groupId;

  @HiveField(6)
  // @override
  final bool isOn;

  const DeviceModel({
    required this.id,
    required this.name,
    required this.familyId,
    required this.createdAt,
    required this.updatedAt,
    required this.groupId,
    required this.isOn,
    // required super.type,
    // required super.status,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      familyId: json['familyId'],
      groupId: json['groupId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isOn: json['isOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'familyId': familyId,
      'groupId': groupId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isOn': isOn,
      // 'type': type,
      // 'status': status,
    };
  }

  factory DeviceModel.fromEntity(DeviceEntity entity) {
    return DeviceModel(
      id: entity.id,
      name: entity.name,
      familyId: entity.familyId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      groupId: entity.groupId,
      isOn: entity.isOn,
    );
  }

  DeviceEntity toEntity() {
    return DeviceEntity(
      id: id,
      name: name,
      familyId: familyId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      groupId: groupId,
      isOn: isOn,
      // type: type,
      // status: status,
    );
  }
}
