import 'package:mobile_pihome/features/authentication/domain/entities/register_device_entity.dart';

class RegisterDeviceModel extends RegisterDeviceEntity {
  const RegisterDeviceModel({
    required super.clientId,
    required super.macAddress,
    super.name,
  });

  factory RegisterDeviceModel.fromJson(Map<String, dynamic> json) {
    return RegisterDeviceModel(
      clientId: json['clientId'],
      macAddress: json['macAddress'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'macAddress': macAddress,
      'name': name,
    };
  }

  RegisterDeviceEntity toEntity() {
    return RegisterDeviceEntity(
      clientId: clientId,
      macAddress: macAddress,
      name: name,
    );
  }
}
