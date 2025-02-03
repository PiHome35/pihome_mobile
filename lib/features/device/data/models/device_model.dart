import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';
part 'device_model.g.dart';

@HiveType(typeId: 0)
class DeviceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String clientId;

  @HiveField(2)
  final String macAddress;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String familyId;

  @HiveField(5)
  final String? deviceGroupId;

  @HiveField(6)
  final bool isOn;

  @HiveField(7)
  final bool isMuted;

  @HiveField(8)
  final int volumePercent;

  @HiveField(9)
  final bool isSoundServer;

  @HiveField(10)
  final String createdAt;

  @HiveField(11)
  final String updatedAt;

  const DeviceModel({
    required this.id,
    required this.clientId,
    required this.macAddress,
    required this.name,
    required this.familyId,
    this.deviceGroupId,
    required this.isOn,
    required this.isMuted,
    required this.volumePercent,
    required this.isSoundServer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    log('device model from json: $json');
    return DeviceModel(
      id: json['id'],
      clientId: json['clientId'],
      macAddress: json['macAddress'],
      name: json['name'],
      familyId: json['familyId'],
      deviceGroupId: json['deviceGroupId'],
      isOn: json['isOn'],
      isMuted: json['isMuted'],
      volumePercent: json['volumePercent'],
      isSoundServer: json['isSoundServer'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'macAddress': macAddress,
      'name': name,
      'familyId': familyId,
      'deviceGroupId': deviceGroupId,
      'isOn': isOn,
      'isMuted': isMuted,
      'volumePercent': volumePercent,
      'isSoundServer': isSoundServer,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory DeviceModel.fromEntity(DeviceEntity entity) {
    return DeviceModel(
      id: entity.id,
      clientId: entity.clientId,
      macAddress: entity.macAddress,
      name: entity.name,
      familyId: entity.familyId,
      deviceGroupId: entity.deviceGroupId,
      isOn: entity.isOn,
      isMuted: entity.isMuted,
      volumePercent: entity.volumePercent,
      isSoundServer: entity.isSoundServer,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  DeviceEntity toEntity() {
    return DeviceEntity(
      id: id,
      clientId: clientId,
      macAddress: macAddress,
      name: name,
      familyId: familyId,
      deviceGroupId: deviceGroupId,
      isOn: isOn,
      isMuted: isMuted,
      volumePercent: volumePercent,
      isSoundServer: isSoundServer,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
