part of 'ble_setup_bloc.dart';

abstract class BleSetupEvent extends Equatable {
  const BleSetupEvent();

  @override
  List<Object?> get props => [];
}

class StartDeviceSetup extends BleSetupEvent {
  final String deviceName;
  final String currentWifiSsid;

  const StartDeviceSetup({
    required this.deviceName,
    required this.currentWifiSsid,
  });

  @override
  List<Object?> get props => [deviceName, currentWifiSsid];
}

final class ReadDeviceInfo extends BleSetupEvent {
  const ReadDeviceInfo();

  @override
  List<Object?> get props => [];
}

final class WriteDeviceSecret extends BleSetupEvent {
  final String secret;
  const WriteDeviceSecret({required this.secret});

  @override
  List<Object?> get props => [secret];
}

class WriteWifiCredentials extends BleSetupEvent {
  final String password;

  const WriteWifiCredentials({
    required this.password,
  });

  @override
  List<Object?> get props => [password];
}

final class TriggerWifiConnection extends BleSetupEvent {
  const TriggerWifiConnection();

  @override
  List<Object?> get props => [];
}

final class CheckSetupStatus extends BleSetupEvent {
  const CheckSetupStatus();

  @override
  List<Object?> get props => [];
}

class RegisterAndConnectDevice extends BleSetupEvent {
  final String deviceName;

  const RegisterAndConnectDevice({
    required this.deviceName,
  });

  @override
  List<Object?> get props => [deviceName];
}
