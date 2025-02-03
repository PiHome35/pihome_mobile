import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

class RegisterDeviceResponseEntity extends Equatable {
  final DeviceEntity device;
  final String clientSecret;

  const RegisterDeviceResponseEntity({
    required this.device,
    required this.clientSecret,
  });

  @override
  List<Object?> get props => [
        device,
        clientSecret,
      ];
}
