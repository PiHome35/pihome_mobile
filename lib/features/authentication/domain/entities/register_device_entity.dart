import 'package:equatable/equatable.dart';

class RegisterDeviceEntity extends Equatable {
  final String clientId;
  final String macAddress;
  final String? name;

  const RegisterDeviceEntity({
    required this.clientId,
    required this.macAddress,
    this.name,
  });

  @override
  List<Object?> get props => [
        clientId,
        macAddress,
        name,
      ];
}
