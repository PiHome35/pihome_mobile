import 'package:mobile_pihome/features/device/data/models/device_model.dart';

class RegisterDeviceResponseModel {
  final DeviceModel device;
  final String clientSecret;

  const RegisterDeviceResponseModel({
    required this.device,
    required this.clientSecret,
  });

  factory RegisterDeviceResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterDeviceResponseModel(
      device: DeviceModel.fromJson(json['device']),
      clientSecret: json['clientSecret'],
    );
  }
}

