import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_pihome/core/resources/data_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/get_storage_token.dart';
import 'package:mobile_pihome/features/device/domain/entities/ble_setup_entity.dart';
import 'package:mobile_pihome/features/device/domain/usecases/ble_setup_usecases.dart';
import 'package:mobile_pihome/features/device/presentation/bloc/local/ble_setup/ble_setup_state.dart';
import 'package:mobile_pihome/features/authentication/domain/usecases/register_device.dart';

part 'ble_setup_event.dart';

@injectable
class BleSetupBloc extends Bloc<BleSetupEvent, BleSetupState> {
  final ReadClientIdUseCase readClientId;
  final ReadMacAddressUseCase readMacAddress;
  final WriteClientSecretUseCase writeClientSecret;
  final WriteWifiSsidUseCase writeWifiSsid;
  final WriteWifiPasswordUseCase writeWifiPassword;
  final TriggerWifiConnectUseCase triggerWifiConnect;
  final CheckSetupCompletedUseCase checkSetupCompleted;
  final RegisterDeviceUseCase registerDevice;
  final GetStorageTokenUseCase getStorageToken;

  BleSetupBloc({
    required this.readClientId,
    required this.readMacAddress,
    required this.writeClientSecret,
    required this.writeWifiSsid,
    required this.writeWifiPassword,
    required this.triggerWifiConnect,
    required this.checkSetupCompleted,
    required this.registerDevice,
    required this.getStorageToken,
  }) : super(const BleSetupInitial()) {
    on<StartDeviceSetup>(_onStartDeviceSetup);
    on<WriteWifiCredentials>(_onWriteWifiCredentials);
    on<RegisterAndConnectDevice>(_onRegisterAndConnectDevice);
  }

  Future<void> _onStartDeviceSetup(
    StartDeviceSetup event,
    Emitter<BleSetupState> emit,
  ) async {
    emit(const BleSetupLoading());
    final setupData = BleSetupEntity(deviceName: event.deviceName);

    try {
      // Step 1: Read Client ID and MAC Address
      final clientIdResult = await readClientId.execute(null);
      final macAddressResult = await readMacAddress.execute(null);

      final clientId = clientIdResult;
      final macAddress = macAddressResult;

      log("clientId: $clientId");
      log("macAddress: $macAddress");

      if (clientId.isEmpty || macAddress.isEmpty) {
        emit(BleSetupError(
          error: "Failed to read device information",
          setupData: setupData,
        ));
        return;
      }

      final updatedSetupData = setupData.copyWith(
        clientId: clientId,
        macAddress: macAddress,
      );

      // Step 2: Write WiFi SSID
      log('event.currentWifiSsid: ${event.currentWifiSsid}');
      await writeWifiSsid.execute(event.currentWifiSsid);

      final setupDataWithSsid = updatedSetupData.copyWith(
        wifiSsid: event.currentWifiSsid,
      );

      emit(BleSetupDeviceInfoRead(setupData: setupDataWithSsid));
    } catch (e) {
      emit(BleSetupError(error: e.toString(), setupData: setupData));
    }
  }

  Future<void> _onWriteWifiCredentials(
    WriteWifiCredentials event,
    Emitter<BleSetupState> emit,
  ) async {
    try {
      emit(BleSetupLoading(setupData: state.setupData));

      // Step 3: Write WiFi Password
      log('event.password: ${event.password}');
      await writeWifiPassword.execute(event.password);

      final updatedSetupData = state.setupData!.copyWith(
        wifiPassword: event.password,
      );

      emit(BleSetupWifiCredentialsWritten(setupData: updatedSetupData));
    } catch (e) {
      emit(BleSetupError(error: e.toString(), setupData: state.setupData));
    }
  }

  Future<void> _onRegisterAndConnectDevice(
    RegisterAndConnectDevice event,
    Emitter<BleSetupState> emit,
  ) async {
    try {
      emit(BleSetupLoading(setupData: state.setupData));

      // Step 5: Register Device
      final accessToken = await getStorageToken.execute(null);
      final registerResult = await registerDevice.execute(RegisterDeviceParams(
        clientId: state.setupData!.clientId!,
        macAddress: state.setupData!.macAddress!,
        name: event.deviceName,
        accessToken: accessToken,
      ));

      if (registerResult is! DataSuccess || registerResult.data == null) {
        emit(BleSetupError(
          error: registerResult is DataFailed
              ? registerResult.exception.toString()
              : "Registration failed",
          setupData: state.setupData,
        ));
        return;
      }

      final clientSecret = registerResult.data!.clientSecret;
      if (clientSecret.isEmpty) {
        emit(BleSetupError(
          error: "Client secret is empty",
          setupData: state.setupData,
        ));
        return;
      }

      // Step 6: Write Client Secret
      await writeClientSecret.execute(clientSecret);

      final updatedSetupData = state.setupData!.copyWith(
        deviceName: event.deviceName,
      );

      emit(BleSetupSecretWritten(setupData: updatedSetupData));

      // Step 7: Trigger WiFi Connect
      await triggerWifiConnect.execute(null);
      emit(BleSetupWifiConnecting(setupData: updatedSetupData));

      // Step 8: Check Setup Complete after delay
      await Future.delayed(const Duration(seconds: 2));
      final isCompleted = await checkSetupCompleted.execute(null);

      if (isCompleted) {
        final finalSetupData = updatedSetupData.copyWith(
          isSetupCompleted: true,
        );
        emit(BleSetupCompleted(setupData: finalSetupData));
      } else {
        emit(BleSetupError(
          error: "Setup is not completed",
          setupData: updatedSetupData,
        ));
      }
    } catch (e) {
      emit(BleSetupError(error: e.toString(), setupData: state.setupData));
    }
  }
}
