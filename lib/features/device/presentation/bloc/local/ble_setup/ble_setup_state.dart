import 'package:mobile_pihome/features/device/domain/entities/ble_setup_entity.dart';

sealed class BleSetupState {
  final BleSetupEntity? setupData;
  final String? errorMessage;

  const BleSetupState({this.setupData, this.errorMessage});
}

final class BleSetupInitial extends BleSetupState {
  const BleSetupInitial() : super();
}

final class BleSetupLoading extends BleSetupState {
  const BleSetupLoading({super.setupData});
}

final class BleSetupDeviceInfoRead extends BleSetupState {
  const BleSetupDeviceInfoRead({required BleSetupEntity setupData})
      : super(setupData: setupData);
}

final class BleSetupSecretWritten extends BleSetupState {
  const BleSetupSecretWritten({required BleSetupEntity setupData})
      : super(setupData: setupData);
}

final class BleSetupWifiCredentialsWritten extends BleSetupState {
  const BleSetupWifiCredentialsWritten({required BleSetupEntity setupData})
      : super(setupData: setupData);
}

final class BleSetupWifiConnecting extends BleSetupState {
  const BleSetupWifiConnecting({required BleSetupEntity setupData})
      : super(setupData: setupData);
}

final class BleSetupCompleted extends BleSetupState {
  const BleSetupCompleted({required BleSetupEntity setupData})
      : super(setupData: setupData);
}

final class BleSetupError extends BleSetupState {
  const BleSetupError({required String error, super.setupData})
      : super(errorMessage: error);
}
