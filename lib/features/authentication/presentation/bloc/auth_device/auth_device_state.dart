import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_pihome/features/device/domain/entities/device_entity.dart';

sealed class AuthDeviceState extends Equatable {
  const AuthDeviceState();

  @override
  List<Object?> get props => [];
}

final class AuthDeviceInitial extends AuthDeviceState {
  const AuthDeviceInitial();
}

final class AuthDeviceLoading extends AuthDeviceState {
  const AuthDeviceLoading();
}

final class AuthDeviceSuccess extends AuthDeviceState {
  final DeviceEntity device;
  final String clientSecret;

  const AuthDeviceSuccess(this.device, this.clientSecret);

  @override
  List<Object?> get props => [
        device,
        clientSecret,
      ];
}

final class AuthDeviceError extends AuthDeviceState {
  final DioException error;

  const AuthDeviceError(this.error);

  @override
  List<Object?> get props => [error];
}
