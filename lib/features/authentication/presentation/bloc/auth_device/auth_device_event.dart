import 'package:equatable/equatable.dart';

sealed class AuthDeviceEvent extends Equatable {
  const AuthDeviceEvent();

  @override
  List<Object?> get props => [];
}

final class RegisterDeviceEvent extends AuthDeviceEvent {
  final String accessToken;
  final String clientId;
  final String macAddress;
  final String name;

  const RegisterDeviceEvent({
    required this.accessToken,
    required this.clientId,
    required this.macAddress,
    required this.name,
  });

  @override
  List<Object?> get props => [accessToken, clientId, macAddress, name];
}
